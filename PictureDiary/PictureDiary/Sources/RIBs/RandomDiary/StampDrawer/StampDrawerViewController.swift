//
//  StampDrawerViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs
import RxSwift
import RxRelay
import RxGesture
import UIKit
import SnapKit
import Then

protocol StampDrawerPresentableListener: AnyObject {
    func didTapCompleteButton()
}

final class StampDrawerViewController: UIViewController, StampDrawerPresentable, StampDrawerViewControllable {

    weak var listener: StampDrawerPresentableListener?
    
    // MARK: - UI Properties
    /// Collection view
    private var collectionView: UICollectionView!

    /// Grdient view
    private let gradientView = UIView()

    /// 취소, 완료 뷰
    private let completionView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.backgroundColor = .white
    }

    /// 완료 버튼
    let btnComplete = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 12
    }

    /// 취소 버튼
    private let btnCancle = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.backgroundColor = .systemRed
        $0.layer.cornerRadius = 12
    }

    // MARK: - Properties
    private let selectedStamp: BehaviorRelay<StampType?>
    private let bag = DisposeBag()

    // MARK: - Lifecycles
    init(
        selectedStamp: BehaviorRelay<StampType?>,
        stampPosition: BehaviorRelay<StampPosition>
    ) {
        self.selectedStamp = selectedStamp
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubviews()
        bind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradient()
    }

    // MARK: - Helpers
    private func setGradient() {
        if let subLayers = gradientView.layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - BaseViewController
extension StampDrawerViewController: BaseViewController {
    func configureView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 80, height: 80)
        layout.minimumLineSpacing = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StampDrawerCell.self, forCellWithReuseIdentifier: StampDrawerCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false

        completionView.addArrangedSubview(btnCancle)
        completionView.addArrangedSubview(btnComplete)

        view.addSubview(completionView)
        view.addSubview(gradientView)
        view.addSubview(collectionView)
    }

    func configureSubviews() {
        collectionView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(94)
        }

        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(collectionView.snp.top)
            $0.leading.trailing.equalTo(collectionView)
            $0.height.equalTo(60)
        }

        btnComplete.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
        }

        btnCancle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
        }

        completionView.snp.makeConstraints {
            $0.edges.equalTo(collectionView).inset(10)
        }
        completionView.isHidden = true
    }
}

// MARK: - Bindable
extension StampDrawerViewController {
    func bind() {
        bindStampList()
        bindButtons()
    }

    func bindStampList() {
        Observable.just(StampType.allCases)
            .bind(to: collectionView.rx.items(
                cellIdentifier: StampDrawerCell.identifier,
                cellType: StampDrawerCell.self
            )) { _, item, cell in
                cell.setStamp(with: item)
            }.disposed(by: bag)

        collectionView.rx.modelSelected(StampType.self)
            .bind(onNext: { [weak self] stamp in
                guard let self = self else { return }
                self.selectedStamp.accept(stamp)
                self.completionView.isHidden = false
                self.collectionView.isHidden = true
            }).disposed(by: bag)
    }

    func bindButtons() {
        btnCancle.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.isHidden = false
                self.completionView.isHidden = true
                self.selectedStamp.accept(nil)
            }).disposed(by: bag)

        btnComplete.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.didTapCompleteButton()
            }).disposed(by: bag)
    }

}
