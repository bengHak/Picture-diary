//
//  FontSettingViewController.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs
import RxSwift
import UIKit

protocol FontSettingPresentableListener: AnyObject {
    func detach()
    func reloadDiaryList()
}

final class FontSettingViewController: UIViewController,
                                       FontSettingPresentable,
                                       FontSettingViewControllable {

    weak var listener: FontSettingPresentableListener?

    // MARK: - UI properties
    /// App bar
    private let appBarTop = AppBarTopView(appBarTopType: .simpleTitle).then {
        $0.setTitle("일기장 폰트 선택")
    }

    private var collectionView: UICollectionView!

    // MARK: - Properties
    private let fontList: [UIFont.DefaultFontType] = [
        .ubiSulGi,
        .kyobo,
        .dulGiMayo,
        .ubiNamSo,
        .ubiQueen,
        .ubiTokyo,
        .ubiPudding,
        .ubiHam
    ]
    private let bag = DisposeBag()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        configureSubviews()
        bind()
    }

    // MARK: - Helpers
}

// MARK: - BaseViewController
extension FontSettingViewController: BaseViewController {
    func configureView() {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat
        if UIScreen.main.traitCollection.userInterfaceIdiom == .phone {
            width = view.frame.width
        } else {
            width = 360
        }
        layout.itemSize = CGSize(width: width, height: 64)
        layout.minimumLineSpacing = 4.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            FontSettingCell.self,
            forCellWithReuseIdentifier: FontSettingCell.identifier
        )

        view.addSubview(appBarTop)
        view.addSubview(collectionView)
    }

    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bindable
extension FontSettingViewController {
    func bind() {
        bindCollectionview()
        bindButtons()
    }

    func bindCollectionview() {
        Observable.of(fontList)
            .bind(to: collectionView.rx.items(
                cellIdentifier: FontSettingCell.identifier,
                cellType: FontSettingCell.self
            )) { _, item, cell in
                cell.setData(item)
            }.disposed(by: bag)

        collectionView.rx.modelSelected(UIFont.DefaultFontType.self)
            .subscribe(onNext: { [weak self] font in
                guard let self = self else { return }
                UserDefaults.setDefaultFont(font)
                self.collectionView.reloadData()
                self.listener?.reloadDiaryList()
            }).disposed(by: bag)
    }

    func bindButtons() {
        appBarTop.btnBack.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.listener?.detach()
            }).disposed(by: bag)
    }
}
