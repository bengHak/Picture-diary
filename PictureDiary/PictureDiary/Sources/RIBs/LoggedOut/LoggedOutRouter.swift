//
//  LoggedOutRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedOutInteractable: Interactable,
                                SNSLoginListener,
                                VanishingCompletionListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable { }

final class LoggedOutRouter: Router<LoggedOutInteractable>, LoggedOutRouting {

    init(interactor: LoggedOutInteractable,
         viewController: LoggedOutViewControllable,
         snsLoginBuilder: SNSLoginBuildable,
         vanishingCompletionBuilder: VanishingCompletionBuildable) {
        self.viewController = viewController
        self.snsLoginBuilder = snsLoginBuilder
        self.vanishingCompletionBuilder = vanishingCompletionBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        routeToSNSLogin()
    }

    func cleanupViews() {
        detachSNSLogin()
        detachVanishingCompletion()
    }

    func routeToSNSLogin() {
        detachVanishingCompletion()
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

    func routeToVanishingCompletion() {
        detachSNSLogin()
        let router = vanishingCompletionBuilder.build(withListener: interactor)
        vanishingCompletionRouter = router
        attachChild(router)

        let vc = router.viewControllable.getFullScreenModalVC()
        viewController.uiviewController.present(vc, animated: true)
    }

    func detachVanishingCompletion() {
        if let router = vanishingCompletionRouter {
            detachChild(router)
            router.viewControllable.uiviewController.dismiss(animated: true)
            self.vanishingCompletionRouter = nil
        }
    }

    // MARK: - Private
    private let viewController: LoggedOutViewControllable

    private let snsLoginBuilder: SNSLoginBuildable
    private var snsLoginRouter: SNSLoginRouting?

    private let vanishingCompletionBuilder: VanishingCompletionBuildable
    private var vanishingCompletionRouter: VanishingCompletionRouting?
}
