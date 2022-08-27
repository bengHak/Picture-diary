//
//  RootInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/04.
//

import RIBs
import RxSwift
import SwiftKeychainWrapper

protocol RootRouting: ViewableRouting {
    func routeToLoggedIn()
    func routeToLoggedOut()
    func routeToSplash()
    func detachSplash()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject { }

final class RootInteractor: PresentableInteractor<RootPresentable>,
                            RootInteractable,
                            RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.routeToSplash()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func routeToLoggedOut() {
        router?.routeToLoggedOut()
    }

    func routeToLoggedIn() {
        router?.routeToLoggedIn()
    }

    func detachToLoggedOut() {
        routeToLoggedOut()
    }

    func checkToken() {
        router?.detachSplash()
        if KeychainWrapper.getValue(forKey: .accessToken) != nil {
            routeToLoggedIn()
        } else {
            routeToLoggedOut()
        }
    }
}
