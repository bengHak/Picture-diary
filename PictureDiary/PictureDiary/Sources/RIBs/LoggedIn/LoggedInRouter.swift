//
//  LoggedInRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedInInteractable: Interactable,
                               DiaryListListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInPrimaryViewControllable: ViewControllable { }
protocol LoggedInSecondaryViewControllable: ViewControllable { }

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    init(interactor: LoggedInInteractable,
         primaryViewController: LoggedInPrimaryViewControllable,
         secondaryViewController: LoggedInSecondaryViewControllable,
         diaryListBuilder: DiaryListBuildable) {
        self.primaryViewController = primaryViewController
        self.secondaryViewController = secondaryViewController
        self.diaryListBuilder = diaryListBuilder
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
        let vc = DiaryListViewController()
        vc.navigationItem.hidesBackButton = true
        primaryViewController.uiviewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func detachDiaryList() {
        if let router = diaryListRouter {
            router.viewControllable.uiviewController.navigationController?.popViewController(animated: false)
            detachChild(router)
        }
    }

    // MARK: - Private
    private let diaryListBuilder: DiaryListBuildable
    private var diaryListRouter: DiaryListRouting?
    
    private let primaryViewController: LoggedInPrimaryViewControllable
    private let secondaryViewController: LoggedInSecondaryViewControllable
}
