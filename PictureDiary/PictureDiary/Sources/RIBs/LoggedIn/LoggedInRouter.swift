//
//  LoggedInRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedInInteractable: Interactable,
                               DiaryListListener,
                               CreateDiaryListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInPrimaryViewControllable: ViewControllable { }
protocol LoggedInSecondaryViewControllable: ViewControllable { }

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    
    init(interactor: LoggedInInteractable,
         primaryViewController: LoggedInPrimaryViewControllable,
         secondaryViewController: LoggedInSecondaryViewControllable,
         diaryListBuilder: DiaryListBuildable,
         createDiaryBuilder: CreateDiaryBuildable) {
        self.primaryViewController = primaryViewController
        self.secondaryViewController = secondaryViewController
        self.diaryListBuilder = diaryListBuilder
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
    }
    
    func routePrimaryToDiaryList() {
        let router = diaryListBuilder.build(withListener: interactor)
        diaryListRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.navigationItem.hidesBackButton = true
        vc.navigationController?.setNavigationBarHidden(true, animated: false)
        primaryViewController.uiviewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func detachDiaryList() {
        if let router = diaryListRouter {
            router.viewControllable.uiviewController.navigationController?.popViewController(animated: false)
            detachChild(router)
        }
    }
    
    func routeToCreateDiary() {
        let router = createDiaryBuilder.build(withListener: interactor)
        createDiaryRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        secondaryViewController.uiviewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func detachCreateDiary() {
        if let router = createDiaryRouter {
            router.viewControllable.uiviewController.navigationController?.popViewController(animated: true)
            detachChild(router)
        }
    }
    
    // MARK: - Private
    private let diaryListBuilder: DiaryListBuildable
    private var diaryListRouter: DiaryListRouting?
    
    private let createDiaryBuilder: CreateDiaryBuildable
    private var createDiaryRouter: CreateDiaryRouting?
    
    private let primaryViewController: LoggedInPrimaryViewControllable
    private let secondaryViewController: LoggedInSecondaryViewControllable
}
