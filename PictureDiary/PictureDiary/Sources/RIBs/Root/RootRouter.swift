//
//  RootRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/04.
//

import RIBs

protocol RootInteractable: Interactable,
                           LoggedOutListener,
                           LoggedInListener,
                           SplashListener {
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
        loggedInBuilder: LoggedInBuildable,
        loggedOutBuilder: LoggedOutBuildable,
        splashBuilder: SplashBuildable
    ) {
        self.splitVC = splitVC
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        self.splashBuilder = splashBuilder

        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - Logged in
    func routeToLoggedIn() {
        detachLoggedOut()
        switchToSplitVC()
        let router = loggedInBuilder.build(withListener: interactor)
        self.loggedInRouter = router
        attachChild(router)
    }

    func detachLoggedIn() {
        if let router = loggedInRouter {
            router.cleanupViews()
            detachChild(router)
            loggedInRouter = nil
        }
    }

    // MARK: - Logged out
    func routeToLoggedOut() {
        detachLoggedIn()
        switchToLoggedOutVC()
        let router = loggedOutBuilder.build(withListener: interactor)
        self.loggedOutRouter = router
        attachChild(router)
    }

    func detachLoggedOut() {
        if let router = loggedOutRouter {
            router.cleanupViews()
            detachChild(router)
            loggedOutRouter = nil
        }
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

    // MARK: - Splash
    func routeToSplash() {
        let router = splashBuilder.build(withListener: interactor)
        self.splashRouter = router
        attachChild(router)
        let vc = router.viewControllable.getFullScreenModalVC()
        viewController.uiviewController.present(vc, animated: false)
    }

    func detachSplash() {
        if let router = splashRouter {
            router.viewControllable.uiviewController.dismiss(animated: false)
            detachChild(router)
            splashRouter = nil
        }
    }

    // MARK: - Private
    private let splitVC: RootSplitViewController

    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?

    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?

    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
}
