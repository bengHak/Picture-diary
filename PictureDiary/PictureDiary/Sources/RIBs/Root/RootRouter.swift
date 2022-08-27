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

    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        splitVC: RootSplitViewController,
        primaryVC: UINavigationController,
        secondaryVC: UINavigationController,
        loggedInBuilder: LoggedInBuildable,
        loggedOutBuilder: LoggedOutBuildable,
        splashBuilder: SplashBuildable
    ) {
        self.splitVC = splitVC
        self.primaryViewController = primaryVC
        self.secondaryViewController = secondaryVC
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        self.splashBuilder = splashBuilder

        // initialize splitVC
        primaryVC.isNavigationBarHidden = true
        secondaryVC.isNavigationBarHidden = true
        if #available(iOS 14.0, *) {
            splitVC.setViewController(primaryVC, for: .primary)
            splitVC.setViewController(secondaryVC, for: .secondary)
        } else {
            splitVC.viewControllers = [primaryVC, secondaryVC]
        }

        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func routeToLoggedIn() {
        if let loggedOutRouter = loggedOutRouter {
            loggedOutRouter.cleanupViews()
            detachChild(loggedOutRouter)
            self.loggedOutRouter = nil
        }
        switchToSplitVC()
        let router = loggedInBuilder.build(withListener: interactor)
        self.loggedInRouter = router
        attachChild(router)
    }

    func routeToLoggedOut() {
        if let loggedInRouter = loggedInRouter {
            loggedInRouter.cleanupViews()
            detachChild(loggedInRouter)
        }
        switchToLoggedOutVC()
        let router = loggedOutBuilder.build(withListener: interactor)
        self.loggedOutRouter = router
        attachChild(router)
    }

    private func switchToSplitVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController.uiviewController.view.window?.rootViewController = self.splitVC
            self.viewController.uiviewController.view.window?.makeKeyAndVisible()
        }
    }

    private func switchToLoggedOutVC() {
        splitVC.uiviewController.view.window?.rootViewController = viewController.uiviewController
        splitVC.uiviewController.view.window?.makeKeyAndVisible()
    }

    // MARK: - Private
    private let splitVC: RootSplitViewController

    private let primaryViewController: UINavigationController
    private let secondaryViewController: UINavigationController

    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?

    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?

    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
}
