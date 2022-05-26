//
//  LoggedOutRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedOutInteractable: Interactable,
                                SNSLoginListener,
                                SignUpCompletedListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable { }

final class LoggedOutRouter: Router<LoggedOutInteractable>, LoggedOutRouting {
    
    init(interactor: LoggedOutInteractable,
         viewController: LoggedOutViewControllable,
         snsLoginBuilder: SNSLoginBuildable,
         signupCompletedBuilder: SignUpCompletedBuildable) {
        self.viewController = viewController
        self.snsLoginBuilder = snsLoginBuilder
        self.signupCompletedBuilder = signupCompletedBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        routeToSNSLogin()
    }

    func cleanupViews() {
        detachSignUpCompleted()
        detachSNSLogin()
    }
    
    func routeToSNSLogin() {
        detachSignUpCompleted()
        let router = snsLoginBuilder.build(withListener: interactor)
        snsLoginRouter = router
        attachChild(router)
        
        let vc = router.viewControllable.getFullScreenModalVC()
        viewController.uiviewController.present(vc, animated: true)
    }
    
    func detachSNSLogin() {
        if let router = snsLoginRouter {
            detachChild(router)
            router.viewControllable.uiviewController.dismiss(animated: true)
            self.snsLoginRouter = nil
        }
    }
    
    func routeToSignUpCompleted() {
        detachSNSLogin()
        let router = signupCompletedBuilder.build(withListener: interactor)
        signupCompletedRouter = router
        attachChild(router)
        
        let vc = router.viewControllable.getFullScreenModalVC()
        viewController.uiviewController.present(vc, animated: true)
    }
    
    func detachSignUpCompleted() {
        if let router = signupCompletedRouter {
            detachChild(router)
            router.viewControllable.uiviewController.dismiss(animated: true)
            self.signupCompletedRouter = nil
        }
    }

    // MARK: - Private
    private let viewController: LoggedOutViewControllable
    
    private let snsLoginBuilder: SNSLoginBuildable
    private var snsLoginRouter: SNSLoginRouting?
    
    private let signupCompletedBuilder: SignUpCompletedBuildable
    private var signupCompletedRouter: SignUpCompletedRouting?
}
