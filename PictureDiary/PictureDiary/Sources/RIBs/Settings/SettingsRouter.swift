//
//  SettingsRouter.swift
//  
//
//  Created by 고병학 on 2022/08/24.
//

import RIBs

protocol SettingsInteractable: Interactable,
                               FontSettingListener,
                               NoticeListener {
    var router: SettingsRouting? { get set }
    var listener: SettingsListener? { get set }
}

protocol SettingsViewControllable: ViewControllable { }

final class SettingsRouter: ViewableRouter<SettingsInteractable, SettingsViewControllable>,
                            SettingsRouting {

    init(
        interactor: SettingsInteractable,
        viewController: SettingsViewControllable,
        fontSetting: FontSettingBuildable,
        notice: NoticeBuildable,
        primaryViewController: UINavigationController
    ) {
        self.fontSettingBuilder = fontSetting
        self.noticeBuilder = notice
        self.navigationController = primaryViewController
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - FontSetting
    func attachFontSetting() {
        let router = fontSettingBuilder.build(withListener: interactor)
        fontSettingRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
    }

    func detachFontSetting() {
        if let router = fontSettingRouter {
            navigationController.popViewController(animated: true)
            detachChild(router)
        }
    }

    // MARK: - Notice
    func attachNotice() {
        let router = noticeBuilder.build(withListener: interactor)
        noticeRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
    }

    func detachNotice() {
        if let router = noticeRouter {
            navigationController.popViewController(animated: true)
            detachChild(router)
        }
    }

    // MARK: - Private
    private let navigationController: UINavigationController

    private let fontSettingBuilder: FontSettingBuildable
    private var fontSettingRouter: FontSettingRouting?

    private let noticeBuilder: NoticeBuildable
    private var noticeRouter: NoticeRouting?
}
