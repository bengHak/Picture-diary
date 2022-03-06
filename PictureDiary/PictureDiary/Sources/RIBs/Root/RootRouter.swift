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
         loggedInBuilder: LoggedInBuildable,
         loggedOutBuilder: LoggedOutBuildable,
         splashBuilder: SplashBuildable) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        self.splashBuilder = splashBuilder
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
        
        let loggedIn = loggedInBuilder.build(withListener: interactor)
        attachChild(loggedIn)
    }
    
    func routeToLoggedOut() {
        if let loggedInRouter = loggedInRouter {
            detachChild(loggedInRouter)
        }
        
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        attachChild(loggedOut)
    }
    
    // MARK: - Private
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOutRouter: LoggedOutRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?
    
    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
}
