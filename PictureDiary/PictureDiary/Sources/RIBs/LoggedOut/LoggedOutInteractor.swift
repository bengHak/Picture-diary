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

    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
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
