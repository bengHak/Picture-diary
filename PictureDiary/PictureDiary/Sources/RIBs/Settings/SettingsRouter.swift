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
        notice: NoticeBuildable
    ) {
        self.fontSettingBuilder = fontSetting
        self.noticeBuilder = notice
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
        viewController.uiviewController.navigationController?.pushViewController(vc, animated: true)
    }

    func detachFontSetting() {
        guard let router = fontSettingRouter,
              let nav = router.viewControllable.uiviewController.navigationController else {
            return
        }
        nav.isNavigationBarHidden = false
        nav.popViewController(animated: true)
        nav.isNavigationBarHidden = true
        detachChild(router)
        fontSettingRouter = nil
    }

    // MARK: - Notice
    func attachNotice() {
        let router = noticeBuilder.build(withListener: interactor)
        noticeRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.navigationItem.hidesBackButton = false
        viewController.uiviewController.navigationController?.pushViewController(vc, animated: true)
    }

    func detachNotice() {
        guard let router = noticeRouter,
        let nav = router.viewControllable.uiviewController.navigationController else {
            return
        }
        nav.isNavigationBarHidden = false
        nav.popViewController(animated: true)
        nav.isNavigationBarHidden = true
        detachChild(router)
        noticeRouter = nil
    }

    // MARK: - Private
    private let fontSettingBuilder: FontSettingBuildable
    private var fontSettingRouter: FontSettingRouting?

    private let noticeBuilder: NoticeBuildable
    private var noticeRouter: NoticeRouting?
}
