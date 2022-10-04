//
//  SettingsInteractor.swift
//  
//
//  Created by 고병학 on 2022/08/24.
//

import RIBs
import RxSwift
import SwiftKeychainWrapper

protocol SettingsRouting: ViewableRouting {
    func attachFontSetting()
    func detachFontSetting()
    func attachNotice()
    func detachNotice()
}

protocol SettingsPresentable: Presentable {
    var listener: SettingsPresentableListener? { get set }

    func showSignoutAlert()
    func showWithdrawlAlert()
}

protocol SettingsListener: AnyObject {
    func detachSettings()
    func detachToLoggedOut()
    func reloadDiaryList()
}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>,
                                SettingsInteractable,
                                SettingsPresentableListener {

    weak var router: SettingsRouting?
    weak var listener: SettingsListener?

    private var authRepository: AuthRepositoryProtocol

    override init(presenter: SettingsPresentable) {
        self.authRepository = AuthRepository()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func detach() {
        listener?.detachSettings()
    }

    func detachFontSetting() {
        router?.detachFontSetting()
    }

    func attachSetting(_ setting: SettingType) {
        switch setting {
        case .font:
            router?.attachFontSetting()
        case .notice:
            router?.attachNotice()
        case .question:
            let email = "mailto:qkwl4678@gmail.com"
            guard let url = URL(string: email) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .signout:
            presenter.showSignoutAlert()
        case .membershipWithdrawal:
            presenter.showWithdrawlAlert()
        case .version:
            print("version")
        }
    }

    func detachNotice() {
        router?.detachNotice()
    }

    func leave() {
        _ = authRepository.leave()
        detachToLoggedOut()
    }

    func detachToLoggedOut() {
        KeychainWrapper.removeValue(forKey: .accessToken)
        listener?.detachToLoggedOut()
    }

    func reloadDiaryList() {
        listener?.reloadDiaryList()
    }
}
