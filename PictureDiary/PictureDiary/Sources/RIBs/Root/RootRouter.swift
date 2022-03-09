//
//  RootRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/04.
//

import RIBs

protocol RootInteractable: Interactable,
                           LoggedOutListener,
                           LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         primaryVC: RootPrimaryViewController,
         secondaryVC: RootSecondaryViewController,
         loggedInBuilder: LoggedInBuildable,
         loggedOutBuilder: LoggedOutBuildable,
         splashBuilder: SplashBuildable) {
        self.primaryViewController = primaryVC
        self.secondaryViewController = secondaryVC
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        self.splashBuilder = splashBuilder
        
        // initialize splitVC
        let primaryNavVC = UINavigationController(rootViewController: primaryViewController)
        let secondaryNavVC = UINavigationController(rootViewController: secondaryViewController)
        if #available(iOS 14.0, *) {
            splitVC = RootSplitViewController(style: .doubleColumn)
            splitVC.setViewController(primaryNavVC, for: .primary)
            splitVC.setViewController(secondaryNavVC, for: .secondary)
        } else {
            splitVC = RootSplitViewController()
            splitVC.viewControllers = [primaryNavVC, secondaryNavVC]
        }
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        routeToLoggedOut()
    }
    
    func routeToLoggedIn() {
        if let loggedOutRouter = loggedOutRouter {
            detachChild(loggedOutRouter)
        }
        switchToSplitVC()
        let loggedIn = loggedInBuilder.build(withListener: interactor)
        attachChild(loggedIn)
    }
    
    func routeToLoggedOut() {
        if let loggedInRouter = loggedInRouter {
            detachChild(loggedInRouter)
        }
        switchToLoggedOutVC()
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        attachChild(loggedOut)
    }
    
    private func switchToSplitVC() {
        viewController.uiviewController.view.window?.rootViewController = splitVC
        viewController.uiviewController.view.window?.makeKeyAndVisible()
    }
    
    private func switchToLoggedOutVC() {
        splitVC.uiviewController.view.window?.rootViewController = viewController.uiviewController
        splitVC.uiviewController.view.window?.makeKeyAndVisible()
    }
    
    // MARK: - Private
    private let splitVC: RootSplitViewController
    
    private let primaryViewController: RootPrimaryViewController
    private let secondaryViewController: RootSecondaryViewController
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?
    
    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
}
