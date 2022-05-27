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
                               VanishingCompletionListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    
    init(interactor: LoggedInInteractable,
         splitViewController: UISplitViewController,
         primaryViewController: UINavigationController,
         secondaryViewController: UINavigationController,
         diaryListBuilder: DiaryListBuildable,
         diaryDetailBuilder: DiaryDetailBuildable,
         createDiaryBuilder: CreateDiaryBuildable,
         vanishingCompletionBuilder: VanishingCompletionBuildable) {
        self.splitViewController = splitViewController
        self.primaryViewController = primaryViewController
        self.secondaryViewController = secondaryViewController
        self.diaryListBuilder = diaryListBuilder
        self.diaryDetailBuilder = diaryDetailBuilder
        self.createDiaryBuilder = createDiaryBuilder
        self.vanishingCompletionBuilder = vanishingCompletionBuilder
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
        vc.navigationItem.hidesBackButton = true
        primaryViewController.pushViewController(vc, animated: false)
    }
    
    private func detachDiaryList() {
        if let router = diaryListRouter {
            primaryViewController.popViewController(animated: false)
            detachChild(router)
        }
    }
    
    // MARK: - DiaryDetail
    func attachDiaryDetail() {
        let router = diaryDetailBuilder.build(withListener: interactor)
        diaryDetailRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc)
    }
    
    func detachDiaryDetail() {
        if let router = diaryDetailRouter {
            popViewController()
            detachChild(router)
        }
    }
    
    // MARK: - CreateDiary
    func attachCreateDiary() {
        let router = createDiaryBuilder.build(withListener: interactor)
        createDiaryRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc)
    }
    
    func detachCreateDiary() {
        if let router = createDiaryRouter {
            popViewController()
            detachChild(router)
            if let vc = diaryListRouter?.viewControllable.uiviewController as? DiaryListViewController {
                vc.fetchDiaryList()
            }
        }
    }
    
    // MARK: - VanishingCompletion
    func attachVanishingCompletion() {
        let router = vanishingCompletionBuilder.build(withListener: interactor)
        vanishingCompletionRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc)
    }
    
    func detachVanishingCompletion() {
        if let router = vanishingCompletionRouter {
            popViewController()
            detachChild(router)
        }
    }
    
    // MARK: - Private
    private let diaryListBuilder: DiaryListBuildable
    private var diaryListRouter: DiaryListRouting?
    
    private let diaryDetailBuilder: DiaryDetailBuildable
    private var diaryDetailRouter: DiaryDetailRouting?
    
    private let createDiaryBuilder: CreateDiaryBuildable
    private var createDiaryRouter: CreateDiaryRouting?
    
    private let vanishingCompletionBuilder: VanishingCompletionBuildable
    private var vanishingCompletionRouter: VanishingCompletionRouting?
    
    private let splitViewController: UISplitViewController
    private let primaryViewController: UINavigationController
    private let secondaryViewController: UINavigationController
    
    // MARK: - Helpers
    private func cleanupPrimaryViews() {
        detachDiaryList()
    }
    
    private func cleanupSecondaryViews() {
        detachDiaryDetail()
        detachCreateDiary()
        detachVanishingCompletion()
    }
    
    private func pushViewController(_ vc: UIViewController) {
        if splitViewController.isCollapsed {
            primaryViewController.pushViewController(vc, animated: false)
        } else {
            secondaryViewController.pushViewController(vc, animated: false)
        }
    }
    
    private func popViewController() {
        if splitViewController.isCollapsed {
            primaryViewController.popViewController(animated: false)
        } else {
            secondaryViewController.popViewController(animated: false)
        }
    }
}
