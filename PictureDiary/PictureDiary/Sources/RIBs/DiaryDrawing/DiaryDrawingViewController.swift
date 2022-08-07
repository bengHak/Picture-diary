//
//  DiaryDrawingViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import PencilKit

protocol DiaryDrawingPresentableListener: AnyObject {
    func detachDiaryDrawing()
}

final class DiaryDrawingViewController: UIViewController, DiaryDrawingPresentable, DiaryDrawingViewControllable {

    weak var listener: DiaryDrawingPresentableListener?

    // MARK: - UI Properties
    /// 앱바
    private let appBarTop = AppBarTopView(appBarTopType: .completion)

    private let upperBorder = UIView().then {
        $0.backgroundColor = UIColor.appColor(.grayscale300)
    }

    /// 그림 그리기 영역
    /// Picture frame 영역 그리는 로직이랑 동일하게
    private var canvasView = PKCanvasView()

    /// undo 버튼
    private let btnUndo = UIButton().then {
        $0.setImage(UIImage(named: "ic_undo_disabled"), for: .normal)
        $0.isHidden = true
    }

    /// redo 버튼
    private let btnRedo = UIButton().then {
        $0.setImage(UIImage(named: "ic_redo_disabled"), for: .normal)
        $0.isHidden = true
    }

    /// 연필 버튼
    private let btnPen = UIButton().then {
        $0.setImage(UIImage(named: "ic_pen_activated"), for: .normal)
    }

    /// 지우개 버튼
    private let btnEraser = UIButton().then {
        $0.setImage(UIImage(named: "ic_eraser_enabled"), for: .normal)
    }

    /// 팔레트 컬렉션 뷰
    private let uiviewPalette = PaletteView()

    /// 모달 뷰
    private lazy var modalView = ModalDialog()

    // MARK: - Properties
    private let bag = DisposeBag()
    private var pen = PKInkingTool(.pencil)
    private var eraser = PKEraserTool(.bitmap)
    private var currentColor = UIColor.paletteColor(.black)
    private var currentStrokeWidth: Float = 10.0
    private var currentTool = ToolType.pen
    private var drawing: PKDrawing?
    private var drawingData: BehaviorRelay<Data?>
    private let drawingImage: BehaviorRelay<UIImage?>

    // MARK: - Lifecycles
    init(
        image: BehaviorRelay<UIImage?>,
        data: BehaviorRelay<Data?>
    ) {
        self.drawingImage = image
        self.drawingData = data
        if let data = data.value {
            self.drawing = try? PKDrawing(data: data)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
        }

        if let drawing = self.drawing {
            canvasView.drawing = drawing
        }

        configureView()
        configureSubviews()
        bind()
    }

    // MARK: - Helpers
    private func toggleUndoRedoButtons() {
        if let manager = undoManager {
            if manager.canUndo {
                btnUndo.setImage(UIImage(named: "ic_undo_enabled"), for: .normal)
            } else {
                btnUndo.setImage(UIImage(named: "ic_undo_disabled"), for: .normal)
            }

            if manager.canRedo {
                btnRedo.setImage(UIImage(named: "ic_redo_enabled"), for: .normal)
            } else {
                btnRedo.setImage(UIImage(named: "ic_redo_disabled"), for: .normal)
            }
        } else {
            btnUndo.isHidden = true
            btnRedo.isHidden = true
        }
    }

    private func showModal() {
        view.addSubview(modalView)
        modalView.snp.makeConstraints { $0.edges.equalToSuperview() }
        modalView.setButton(message: "변경사항을 저장하지 않으시겠어요?", leftMessage: "취소", rightMessage: "네")
        bindModalButtons()
    }
}

extension DiaryDrawingViewController: BaseViewController {
    func configureView() {
        canvasView.delegate = self
        canvasView.tool = pen

        [appBarTop, upperBorder, canvasView, btnUndo, btnRedo, uiviewPalette, btnPen, btnEraser]
            .forEach { view.addSubview($0) }
    }

    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        upperBorder.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }

        btnRedo.snp.makeConstraints {
            $0.top.trailing.equalTo(upperBorder).inset(20)
            $0.width.height.equalTo(32)
        }

        btnUndo.snp.makeConstraints {
            $0.top.equalTo(upperBorder).inset(20)
            $0.trailing.equalTo(btnRedo.snp.leading).offset(-20)
            $0.width.height.equalTo(32)
        }

        uiviewPalette.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(164)
        }

        canvasView.snp.makeConstraints {
            $0.top.equalTo(upperBorder.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(uiviewPalette.snp.top)
        }

        btnEraser.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(uiviewPalette.snp.top).offset(-20)
            $0.width.height.equalTo(40)
        }

        btnPen.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(btnEraser.snp.top).offset(-20)
            $0.width.height.equalTo(40)
        }
    }
}

// MARK: - Bindable
extension DiaryDrawingViewController {
    func bind() {
        bindStrokeColor()
        bindStrokeWidth()
        bindButtons()
        bindAppBarButtons()
    }

    func bindStrokeColor() {
        uiviewPalette.selectedColorIndex
            .subscribe(onNext: { [weak self] colorIndex in
                guard let self = self else { return }
                let color = UIColor.paletteColor(PaletteColorType.getByHashValue(colorIndex))
                self.currentColor = color
                self.pen.color = color

                if self.currentTool == .pen {
                    self.canvasView.tool = self.pen
                }
            }).disposed(by: bag)
    }

    func bindStrokeWidth() {
        uiviewPalette.selectedStrokeSize
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.currentStrokeWidth = value
                self.pen.width = CGFloat(value)

                if self.currentTool == .pen {
                    self.canvasView.tool = self.pen
                }
            }).disposed(by: bag)
    }

    func bindButtons() {
        btnPen.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.canvasView.tool = self.pen
                self.currentTool = .pen
                DispatchQueue.main.async {
                    self.btnPen.setImage(UIImage(named: "ic_pen_activated"), for: .normal)
                    self.btnEraser.setImage(UIImage(named: "ic_eraser_enabled"), for: .normal)
                }
            }).disposed(by: bag)

        btnEraser.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.canvasView.tool = self.eraser
                self.currentTool = .eraser
                DispatchQueue.main.async {
                    self.btnPen.setImage(UIImage(named: "ic_pen_enabled"), for: .normal)
                    self.btnEraser.setImage(UIImage(named: "ic_eraser_activated"), for: .normal)
                }
            }).disposed(by: bag)

        btnUndo.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.undoManager?.undo()
                self.toggleUndoRedoButtons()
            }).disposed(by: bag)

        btnRedo.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.undoManager?.redo()
                self.toggleUndoRedoButtons()
            }).disposed(by: bag)
    }

    func bindAppBarButtons() {
        appBarTop.btnBack.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showModal()
            }).disposed(by: bag)

        appBarTop.btnCompleted.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let drawingData = self.canvasView.drawing.dataRepresentation()
                let image = self.canvasView.drawing.image(from: self.canvasView.bounds, scale: 1.0)
                self.drawingImage.accept(image)
                self.drawingData.accept(drawingData)

                self.listener?.detachDiaryDrawing()
            }).disposed(by: bag)
    }

    func bindModalButtons() {
        modalView.btnLeft.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modalView.removeFromSuperview()
            }).disposed(by: bag)

        modalView.btnRight.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.detachDiaryDrawing()
            }).disposed(by: bag)
    }
}

// MARK: PKCanvasViewDelegate
extension DiaryDrawingViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        btnRedo.isHidden = false
        btnUndo.isHidden = false
        btnUndo.setImage(UIImage(named: "ic_undo_enabled"), for: .normal)
    }
}
