//
//  SplashInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift

protocol SplashRouting: ViewableRouting { }

protocol SplashPresentable: Presentable {
    var listener: SplashPresentableListener? { get set }
}

protocol SplashListener: AnyObject {
    func checkToken()
}

final class SplashInteractor: PresentableInteractor<SplashPresentable>, SplashInteractable, SplashPresentableListener {

    weak var router: SplashRouting?
    weak var listener: SplashListener?

    override init(presenter: SplashPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func checkToken() {
        listener?.checkToken()
    }
}
