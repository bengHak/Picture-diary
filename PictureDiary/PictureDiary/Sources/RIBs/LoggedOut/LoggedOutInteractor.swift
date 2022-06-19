//
//  LoggedOutInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: Routing {
    func cleanupViews()
    func routeToVanishingCompletion()
}

protocol LoggedOutListener: AnyObject {
    func routeToLoggedIn()
}

final class LoggedOutInteractor: Interactor, LoggedOutInteractable {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func didLogin() {
        router?.cleanupViews()
        listener?.routeToLoggedIn()
    }
    
    func didSignUp() {
        router?.routeToVanishingCompletion()
    }
    
    func detachCompletionView() {
        listener?.routeToLoggedIn()
    }
}
