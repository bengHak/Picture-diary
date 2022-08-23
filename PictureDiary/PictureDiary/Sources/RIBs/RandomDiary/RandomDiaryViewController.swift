//
//  RandomDiaryViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit
import Then

protocol RandomDiaryPresentableListener: AnyObject {
    func didTapBackButton()
}

final class RandomDiaryViewController: UIViewController, RandomDiaryPresentable, RandomDiaryViewControllable {

    weak var listener: RandomDiaryPresentableListener?

    // MARK: - UI Properties
    private let appBarTopBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    private let appBarTop = AppBarTopView(appBarTopType: .simpleTitle)

    private var movableStampView: UIView?

    // MARK: - Properties
    private let selectedStamp: BehaviorRelay<StampType?>
    private let stampPosition: BehaviorRelay<StampPosition>
    private var diaryDetailViewController: UIViewController?
    private var stampDrawerViewController: UIViewController?
    private let bag = DisposeBag()

    // MARK: - Lifecycles
    init(
        selectedStamp: BehaviorRelay<StampType?>,
        stampPosition: BehaviorRelay<StampPosition>
    ) {
        self.selectedStamp = selectedStamp
        self.stampPosition = stampPosition
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Helpers
    func addDiaryDetail(_ vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        diaryDetailViewController = vc
        vc.view.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        vc.didMove(toParent: self)

        configureView()
        configureSubviews()
        bind()
    }

    func detachDetailView() {
        diaryDetailViewController?.willMove(toParent: nil)
        diaryDetailViewController?.removeFromParent()
        diaryDetailViewController?.view.removeFromSuperview()
        diaryDetailViewController = nil
    }

    func addStampDrawerView(_ vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        stampDrawerViewController = vc

        diaryDetailViewController?.view.snp.remakeConstraints {
            $0.top.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-94)
        }

        vc.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-94)
            $0.leading.trailing.bottom.equalTo(view)
        }

        vc.didMove(toParent: self)
    }

    func detachStampDrawer() {
        stampDrawerViewController?.willMove(toParent: nil)
        stampDrawerViewController?.removeFromParent()
        stampDrawerViewController?.view.removeFromSuperview()
        stampDrawerViewController = nil
    }

    private func addMovableStampView(_ stamp: StampType) {
        guard let diaryDetailViewController = diaryDetailViewController as? DiaryDetailViewController else {
            return
        }

        let movable = UIView()
        let imageView = UIImageView(image: UIImage(named: stamp.imageName)!)

        movable.addSubview(imageView)
        self.view.addSubview(movable)

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }

        movable.snp.makeConstraints {
            $0.center.equalTo(diaryDetailViewController.ivPictureFrame)
            $0.width.height.equalTo(80)
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveStampPosition(gesture:)))
        movable.addGestureRecognizer(panGesture)

        movableStampView = movable
    }

    private func removeMovableStampView() {
        guard let movableStampView = movableStampView else {
            return
        }
        movableStampView.removeFromSuperview()
        self.movableStampView = nil
    }

    @objc
    private func moveStampPosition(gesture: UIPanGestureRecognizer) {
        guard let diaryDetailViewController = diaryDetailViewController as? DiaryDetailViewController,
              let movable = movableStampView else {
            return
        }

        let stackView = diaryDetailViewController.stackView
        let pictureFrame = diaryDetailViewController.ivPictureFrame
        let pictureFrameOrigin = stackView.convert(
            pictureFrame.frame.origin,
            to: diaryDetailViewController.view
        )
        let poX = pictureFrameOrigin.x
        let poY = pictureFrameOrigin.y

        let translation = gesture.translation(in: pictureFrame)

        var targetPoint = CGPoint.init(
            x: movable.center.x + translation.x,
            y: movable.center.y + translation.y
        )

        targetPoint.x = min(
            poX+pictureFrame.bounds.width-40,
            max(poX+40, targetPoint.x)
        )

        targetPoint.y = min(
            poY+pictureFrame.bounds.height-40,
            max(poY+40, targetPoint.y)
        )

        let w = pictureFrame.bounds.width
        let h = pictureFrame.bounds.height
        let proportionalX: Double = (targetPoint.x - 40 - poX)/w
        let proportionalY: Double = (targetPoint.y - 40 - poY)/h

        movable.center = targetPoint
        stampPosition.accept(
            StampPosition(
                x: targetPoint.x,
                y: targetPoint.y,
                proportionalX: proportionalX,
                proportionalY: proportionalY
            )
        )
        gesture.setTranslation(CGPoint.zero, in: pictureFrame)
    }
}

// MARK: - BaseViewController
extension RandomDiaryViewController: BaseViewController {
    func configureView() {
        view.addSubview(appBarTopBackgroundView)
        appBarTop.setTitle("다른사람의 일기")
        view.addSubview(appBarTop)
    }

    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        appBarTop.layer.zPosition = 25

        appBarTopBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(appBarTop)
        }
        appBarTopBackgroundView.layer.zPosition = 20
    }
}

// MARK: - Bindable
extension RandomDiaryViewController {
    func bind() {
        bindButtons()
        bindStamp()
        bindStampPosition()
    }

    func bindButtons() {
        appBarTop.btnBack.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.listener?.didTapBackButton()
            }).disposed(by: bag)
    }

    func bindStamp() {
        selectedStamp
            .subscribe(onNext: { [weak self] stamp in
                guard let self = self,
                      let stamp = stamp else {
                    self?.removeMovableStampView()
                    return
                }

                if self.movableStampView != nil {
                    self.removeMovableStampView()
                }
                self.addMovableStampView(stamp)
            }).disposed(by: bag)
    }

    func bindStampPosition() {
        stampPosition
            .throttle(.milliseconds(500), latest: true, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pos in
                guard let self = self,
                      let movable = self.movableStampView,
                      let diaryDetailViewController = self.diaryDetailViewController as? DiaryDetailViewController,
                      let proportionalX = pos.proportionalX,
                      let proportionalY = pos.proportionalY else {
                    return
                }
                let pictureFrame = diaryDetailViewController.ivPictureFrame
                let w = pictureFrame.frame.width
                let h = pictureFrame.frame.height
                movable.snp.remakeConstraints {
                    $0.leading.equalTo(pictureFrame).offset(proportionalX * w)
                    $0.top.equalTo(pictureFrame).offset(proportionalY * h)
                    $0.width.height.equalTo(80)
                }
            }).disposed(by: bag)
    }
}

struct StampPosition {
    var x: Double
    var y: Double
    var proportionalX: Double?
    var proportionalY: Double?
}
