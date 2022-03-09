//
//  LoggedInRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedInInteractable: Interactable,
                               HomeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInPrimaryViewControllable: ViewControllable { }
protocol LoggedInSecondaryViewControllable: ViewControllable { }

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    init(interactor: LoggedInInteractable,
         primaryViewController: LoggedInPrimaryViewControllable,
         secondaryViewController: LoggedInSecondaryViewControllable,
         homeBuilder: HomeBuildable) {
        self.primaryViewController = primaryViewController
        self.secondaryViewController = secondaryViewController
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        routeToHome()
    }

    func cleanupViews() {
        detachHome()
    }
    
    func routeToHome() {
        let router = homeBuilder.build(withListener: interactor)
        homeRouter = router
        attachChild(router)
        let vc = HomeViewController()
        vc.navigationItem.hidesBackButton = true
        primaryViewController.uiviewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func detachHome() {
        if let router = homeRouter {
            detachChild(router)
            primaryViewController.uiviewController.navigationController?.popToRootViewController(animated: false)
            secondaryViewController.uiviewController.navigationController?.popToRootViewController(animated: false)
        }
    }

    // MARK: - Private
    
    private let homeBuilder: HomeBuildable
    private var homeRouter: HomeRouting?
    
    private let primaryViewController: LoggedInPrimaryViewControllable
    private let secondaryViewController: LoggedInSecondaryViewControllable
}
