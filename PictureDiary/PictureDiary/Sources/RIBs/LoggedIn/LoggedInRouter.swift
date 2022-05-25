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
                               CreateDiaryListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInSplitViewControllable: ViewControllable { }
protocol LoggedInPrimaryViewControllable: ViewControllable { }
protocol LoggedInSecondaryViewControllable: ViewControllable { }

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    
    init(interactor: LoggedInInteractable,
         splitViewController: LoggedInSplitViewControllable,
         primaryViewController: LoggedInPrimaryViewControllable,
         secondaryViewController: LoggedInSecondaryViewControllable,
         diaryListBuilder: DiaryListBuildable,
         diaryDetailBuilder: DiaryDetailBuildable,
         createDiaryBuilder: CreateDiaryBuildable) {
        self.splitViewController = splitViewController
        self.primaryViewController = primaryViewController
        self.secondaryViewController = secondaryViewController
        self.diaryListBuilder = diaryListBuilder
        self.diaryDetailBuilder = diaryDetailBuilder
        self.createDiaryBuilder = createDiaryBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        routePrimaryToDiaryList()
    }
    
    func cleanupViews() {
        detachDiaryList()
        detachCreateDiary()
    }
    
    func routePrimaryToDiaryList() {
        let router = diaryListBuilder.build(withListener: interactor)
        diaryListRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.navigationItem.hidesBackButton = true
        primaryViewController.uiviewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func detachDiaryList() {
        if let router = diaryListRouter {
            router.viewControllable.uiviewController.navigationController?.popViewController(animated: false)
            detachChild(router)
        }
    }
    
    func routeToDiaryDetail() {
        let router = diaryDetailBuilder.build(withListener: interactor)
        diaryDetailRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        splitViewController.uiviewController.showDetailViewController(vc, sender: nil)
    }
    
    func detachDiaryDetail() {
        if let router = diaryDetailRouter {
            let navC = router.viewControllable.uiviewController.navigationController
            navC?.popToRootViewController(animated: false)
            navC?.navigationController?.popViewController(animated: false)
            detachChild(router)
        }
    }
    
    func routeToCreateDiary() {
        let router = createDiaryBuilder.build(withListener: interactor)
        createDiaryRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        splitViewController.uiviewController.showDetailViewController(vc, sender: nil)
    }
    
    func detachCreateDiary() {
        if let router = createDiaryRouter {
            let navC = router.viewControllable.uiviewController.navigationController
            navC?.popToRootViewController(animated: false)
            navC?.navigationController?.popViewController(animated: false)
            detachChild(router)
            
            if let vc = diaryListRouter?.viewControllable.uiviewController as? DiaryListViewController {
                vc.fetchDiaryList()
            }
        }
    }
    
    // MARK: - Private
    private let diaryListBuilder: DiaryListBuildable
    private var diaryListRouter: DiaryListRouting?
    
    private let diaryDetailBuilder: DiaryDetailBuildable
    private var diaryDetailRouter: DiaryDetailRouting?
    
    private let createDiaryBuilder: CreateDiaryBuildable
    private var createDiaryRouter: CreateDiaryRouting?
    
    private let splitViewController: LoggedInSplitViewControllable
    private let primaryViewController: LoggedInPrimaryViewControllable
    private let secondaryViewController: LoggedInSecondaryViewControllable
}
