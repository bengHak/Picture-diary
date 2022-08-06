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
                               RandomDiaryListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    
    init(
        interactor: LoggedInInteractable,
        splitViewController: UISplitViewController,
        primaryViewController: UINavigationController,
        secondaryViewController: UINavigationController,
        diaryListBuilder: DiaryListBuildable,
        diaryDetailBuilder: DiaryDetailBuildable,
        createDiaryBuilder: CreateDiaryBuildable,
        randomDiaryBuilder: RandomDiaryBuildable
    ) {
        self.splitViewController = splitViewController
        self.primaryViewController = primaryViewController
        self.secondaryViewController = secondaryViewController
        self.diaryListBuilder = diaryListBuilder
        self.diaryDetailBuilder = diaryDetailBuilder
        self.createDiaryBuilder = createDiaryBuilder
        self.randomDiaryBuilder = randomDiaryBuilder
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
    
    func detachDiaryList() {
        if let router = diaryListRouter {
            popViewController(router.viewControllable.uiviewController)
            detachChild(router)
        }
    }

    // MARK: - DiaryDetail
    func attachDiaryDetail() {
        cleanupSecondaryViews()
        let router = diaryDetailBuilder.build(withListener: interactor)
        diaryDetailRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, animated: true)
    }

    func detachDiaryDetail() {
        if let router = diaryDetailRouter {
            popViewController(router.viewControllable.uiviewController, animated: true)
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
        pushViewController(vc, animated: true)
    }
    
    func detachCreateDiary() {
        if let router = createDiaryRouter {
            popViewController(router.viewControllable.uiviewController)
            detachChild(router)
        }
    }

    // MARK: - RandomDiary
    func attachRandomDiary() {
        cleanupSecondaryViews()
        let router = randomDiaryBuilder.build(withListener: interactor)
        randomDiaryRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        pushViewController(vc, animated: true)
    }
   
    func detachRandomDiary() {
        if let router = randomDiaryRouter {
            popViewController(router.viewControllable.uiviewController)
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

    private let randomDiaryBuilder: RandomDiaryBuildable
    private var randomDiaryRouter: RandomDiaryRouting?

    private let splitViewController: UISplitViewController
    private let primaryViewController: UINavigationController
    private let secondaryViewController: UINavigationController

    // MARK: - Helpers
    private func cleanupPrimaryViews() {
        detachDiaryList()
    }

    private func cleanupSecondaryViews() {
        if diaryDetailRouter != nil {
            detachDiaryDetail()
            diaryDetailRouter = nil
        }

        if createDiaryRouter != nil {
            detachCreateDiary()
            createDiaryRouter = nil
        }

        if randomDiaryRouter != nil {
            detachRandomDiary()
            randomDiaryRouter = nil
        }
    }

    private func pushViewController(_ vc: UIViewController, animated: Bool = false) {
        if splitViewController.isCollapsed {
            primaryViewController.pushViewController(vc, animated: animated)
        } else {
            secondaryViewController.pushViewController(vc, animated: false)
        }
    }

    private func popViewController(_ viewController: UIViewController, animated: Bool = false) {
        if let vc = viewController.navigationController?.topViewController,
           vc === viewController {
            if splitViewController.isCollapsed {
                vc.navigationController?.popViewController(animated: animated)
            } else {
                vc.navigationController?.popViewController(animated: false)
            }
        }
    }
}
