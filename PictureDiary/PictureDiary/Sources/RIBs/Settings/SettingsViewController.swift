//
//  SettingsViewController.swift
//  
//
//  Created by 고병학 on 2022/08/24.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import SwiftKeychainWrapper

protocol SettingsPresentableListener: AnyObject {
    func detach()
    func attachSetting(_ setting: SettingType)
    func detachToLoggedOut()
    func leave()
}

final class SettingsViewController: UIViewController,
                                    SettingsPresentable,
                                    SettingsViewControllable {

    weak var listener: SettingsPresentableListener?

    // MARK: - UI properties
    /// App bar
    private let appBarTop = AppBarTopView(appBarTopType: .simpleTitle).then {
        $0.setTitle("설정")
    }

    /// 설정 목록
    private var collectionView: UICollectionView!

    private let modalView = ModalDialog()

    // MARK: - Properties
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
    func showSignoutAlert() {
        modalView.setButton(message: "로그아웃 하시겠어요?", leftMessage: "아니오", rightMessage: "네")
        modalView.isHidden = false
        bindModalButtons(isSignout: true)
    }

    func showWithdrawlAlert() {
        modalView.setButton(message: "정말 탈퇴 하시겠어요?", leftMessage: "아니오", rightMessage: "네")
        modalView.isHidden = false
        bindModalButtons(isSignout: false)
    }
}

// MARK: - BaseViewController
extension SettingsViewController: BaseViewController {
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
            SettingsCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingsCollectionViewCell.identifier
        )

        view.addSubview(appBarTop)
        view.addSubview(collectionView)
        view.addSubview(modalView)
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

        modalView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.bottom.equalToSuperview()
        }
        modalView.isHidden = true
    }
}

// MARK: - Bindable
extension SettingsViewController {
    func bind() {
        bindCollectionView()
        bindButtons()
    }

    func bindCollectionView() {
        Observable.of([
            .font,
            .notice,
            .question,
            .signout,
            .membershipWithdrawal,
            .version
        ])
            .bind(to: collectionView.rx.items(
                cellIdentifier: SettingsCollectionViewCell.identifier,
                cellType: SettingsCollectionViewCell.self
            )) { _, item, cell in
                cell.setData(item)
            }.disposed(by: bag)

        collectionView.rx.modelSelected(SettingType.self)
            .subscribe(onNext: { [weak self] setting in
                guard let self = self else { return }
                self.listener?.attachSetting(setting)
            }).disposed(by: bag)
    }

    func bindButtons() {
        appBarTop.btnBack.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.listener?.detach()
            }).disposed(by: bag)
    }

    func bindModalButtons(isSignout: Bool) {
        modalView.btnLeft.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modalView.isHidden = true
            }).disposed(by: bag)

        modalView.btnRight.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modalView.isHidden = true
                if !isSignout {
                    self.listener?.leave()
                } else {
                    self.listener?.detachToLoggedOut()
                }
            }).disposed(by: bag)
    }
}
