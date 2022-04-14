//
//  DiaryDrawingViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import PencilKit

protocol DiaryDrawingPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class DiaryDrawingViewController: UIViewController, DiaryDrawingPresentable, DiaryDrawingViewControllable {
    
    weak var listener: DiaryDrawingPresentableListener?
    
    // MARK: - UI Properties
    /// 앱바
    ///
    /// 그림 그리기 영역
    /// Picture frame 영역 그리는 로직이랑 동일하게
    private let canvasView = PKCanvasView()
    
    /// 연필 버튼
    //    private let btnPencil = UIButton().then {
    //        $0.setImage(UIImage(named: "ic_pencil"), for: .normal)
    //    }
    
    /// 지우개 버튼
    //    private let btnEraser = UIButton().then {
    //        $0.setImage(UIImage(named: "ic_eraser"), for: .normal)
    //    }
    
    /// 팔레트 컬렉션 뷰
    private let uiviewPalette = PaletteView()
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var currentColor = UIColor.paletteColor(.black)
    private var currentStrokeWidth: Float = 10.0
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
        }
        
        configureView()
        configureSubviews()
        bind()
    }
    
    // MARK: - Helpers
}

extension DiaryDrawingViewController: BaseViewController {
    func configureView() {
        view.addSubview(canvasView)
        view.addSubview(uiviewPalette)
    }
    
    func configureSubviews() {
        canvasView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        uiviewPalette.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(164)
        }
    }
}

// MARK: Bindable
extension DiaryDrawingViewController {
    func bind() {
        bindStrokeColor()
        bindStrokeWidth()
    }
    
    func bindStrokeColor() {
        uiviewPalette.selectedColorIndex
            .subscribe(onNext: { [weak self] colorIndex in
                guard let self = self else { return }
                let color = PaletteColorType.getByHashValue(colorIndex)
                self.currentColor = UIColor.paletteColor(color)
                self.canvasView.tool = PKInkingTool(
                    .pen,
                    color: self.currentColor,
                    width: CGFloat(self.currentStrokeWidth)
                )
            }).disposed(by: bag)
    }
    
    func bindStrokeWidth() {
        uiviewPalette.selectedStrokeSize
            .throttle(.milliseconds(5), latest: true, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.currentStrokeWidth = value
                self.canvasView.tool = PKInkingTool(
                    .pen,
                    color: self.currentColor,
                    width: CGFloat(value)
                )
            }).disposed(by: bag)
    }
}
