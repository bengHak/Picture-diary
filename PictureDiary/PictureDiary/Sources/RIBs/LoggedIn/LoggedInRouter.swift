//
//  LoggedInRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedInInteractable: Interactable,
                               DiaryListListener,
                               DiaryDetailListener,
                               CreateDiaryListener,
                               RandomDiaryListener,
                               SettingsListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    init(
        interactor: LoggedInInteractable,
        splitViewController: UISplitViewController,
        diaryListBuilder: DiaryListBuildable,
        diaryDetailBuilder: DiaryDetailBuildable,
        createDiaryBuilder: CreateDiaryBuildable,
        randomDiaryBuilder: RandomDiaryBuildable,
        settingsBuilder: SettingsBuildable
    ) {
        self.splitViewController = splitViewController
        self.diaryListBuilder = diaryListBuilder
        self.diaryDetailBuilder = diaryDetailBuilder
        self.createDiaryBuilder = createDiaryBuilder
        self.randomDiaryBuilder = randomDiaryBuilder
        self.settingsBuilder = settingsBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachDirayListAtPrimary()
    }

    func cleanupViews() {
        cleanupPrimaryViews()
        cleanupSecondaryViews()
    }

    // MARK: - DiaryList
    func attachDirayListAtPrimary() {
        let router = diaryListBuilder.build(withListener: interactor)
        diaryListRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, isPrimary: true, animated: false)
    }

    func detachDiaryList(animated: Bool) {
        if let router = diaryListRouter {
            popViewController(router.viewControllable.uiviewController, isPrimary: true, animated: animated)
            detachChild(router)
            diaryListRouter = nil
        }
    }

    // MARK: - Settings
    func attachSettings() {
        let router = settingsBuilder.build(withListener: interactor)
        settingsRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, isPrimary: true, animated: true)
    }

    func detachSettings(animated: Bool) {
        if let router = settingsRouter {
            popViewController(router.viewControllable.uiviewController, isPrimary: true, animated: animated)
            detachChild(router)
            settingsRouter = nil
        }
    }

    // MARK: - DiaryDetail
    func attachDiaryDetail() {
        cleanupSecondaryViews()
        let router = diaryDetailBuilder.build(withListener: interactor)
        diaryDetailRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, isPrimary: false, animated: true)
    }

    func detachDiaryDetail() {
        if let router = diaryDetailRouter {
            popViewController(router.viewControllable.uiviewController, isPrimary: false, animated: true)
            detachChild(router)
        }
    }

    // MARK: - CreateDiary
    func attachCreateDiary() {
        cleanupSecondaryViews()
        let router = createDiaryBuilder.build(withListener: interactor)
        createDiaryRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, isPrimary: false, animated: true)
    }

    func detachCreateDiary() {
        if let router = createDiaryRouter {
            popViewController(router.viewControllable.uiviewController, isPrimary: false)
            detachChild(router)
            createDiaryRouter = nil
        }
    }

    // MARK: - RandomDiary
    func attachRandomDiary() {
        cleanupSecondaryViews()
        let router = randomDiaryBuilder.build(withListener: interactor)
        randomDiaryRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, isPrimary: false, animated: true)
    }

    func detachRandomDiary() {
        if let router = randomDiaryRouter {
            popViewController(router.viewControllable.uiviewController, isPrimary: false, animated: true)
            detachChild(router)
            randomDiaryRouter = nil
        }
    }

    // MARK: - Private
    private let diaryListBuilder: DiaryListBuildable
    private var diaryListRouter: DiaryListRouting?

    private let diaryDetailBuilder: DiaryDetailBuildable
    private var diaryDetailRouter: DiaryDetailRouting?

    private let createDiaryBuilder: CreateDiaryBuildable
    private var createDiaryRouter: CreateDiaryRouting?

    private let randomDiaryBuilder: RandomDiaryBuildable
    private var randomDiaryRouter: RandomDiaryRouting?

    private let settingsBuilder: SettingsBuildable
    private var settingsRouter: SettingsRouting?

    private let splitViewController: UISplitViewController

    // MARK: - Helpers
    private func cleanupPrimaryViews() {
        detachDiaryList(animated: false)
        detachSettings(animated: false)
    }

    private func cleanupSecondaryViews() {
        detachDiaryDetail()
        detachCreateDiary()
        detachRandomDiary()
    }

    private func pushViewController(
        _ vc: UIViewController,
        isPrimary: Bool,
        animated: Bool = false
    ) {
        if #available(iOS 14.0, *) {
            var animated = animated
            var column: UISplitViewController.Column!
            if splitViewController.isCollapsed || isPrimary {
                column = .primary
            } else {
                column = .secondary
                animated = false
            }
            if let nav = splitViewController.viewController(for: column)?.navigationController {
                nav.setNavigationBarHidden(true, animated: false)
                nav.pushViewController(vc, animated: animated)
            }
        }
    }

    private func popViewController(
        _ viewController: UIViewController,
        isPrimary: Bool,
        animated: Bool = false
    ) {
        if #available(iOS 14.0, *) {
            let animated = animated && splitViewController.isCollapsed
            var column: UISplitViewController.Column!
            if splitViewController.isCollapsed || isPrimary {
                column = .primary
            } else {
                column = .secondary
            }
            if let nav = splitViewController.viewController(for: column)?.navigationController,
               let vc = nav.topViewController,
               vc === viewController {
                nav.setNavigationBarHidden(false, animated: false)
                nav.popViewController(animated: animated)
                nav.setNavigationBarHidden(true, animated: false)
            }
        }
    }
}
