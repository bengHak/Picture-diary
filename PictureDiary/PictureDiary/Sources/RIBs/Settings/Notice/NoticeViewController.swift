//
//  NoticeViewController.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

protocol NoticePresentableListener: AnyObject {
    func detach()
}

final class NoticeViewController: UIViewController, NoticePresentable, NoticeViewControllable {

    weak var listener: NoticePresentableListener?

    // MARK: - UI properties
    /// App bar
    private let appBarTop = AppBarTopView(appBarTopType: .simpleTitle).then {
        $0.setTitle("공지사항")
    }

    private var collectionView: UICollectionView!

    // MARK: - Properties
    private let noticeList: [String] = []
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
extension NoticeViewController: BaseViewController {
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
extension NoticeViewController {
    func bind() {
        bindCollectionview()
        bindButtons()
    }

    func bindCollectionview() {
        Observable.of(noticeList)
            .bind(to: collectionView.rx.items(
                cellIdentifier: NoticeCell.identifier,
                cellType: NoticeCell.self
            )) { _, item, cell in
                cell.setData(item)
            }.disposed(by: bag)

        collectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { notice in
                print(notice)
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
