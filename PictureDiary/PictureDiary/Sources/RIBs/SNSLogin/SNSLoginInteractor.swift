//
//  SNSLoginInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift

protocol SNSLoginRouting: ViewableRouting { }

protocol SNSLoginPresentable: Presentable {
    var listener: SNSLoginPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SNSLoginListener: AnyObject {
    func didLogin()
    func didSignUp()
}

final class SNSLoginInteractor: PresentableInteractor<SNSLoginPresentable>,
                                SNSLoginInteractable,
                                SNSLoginPresentableListener {
    weak var router: SNSLoginRouting?
    weak var listener: SNSLoginListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SNSLoginPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func login() {
        listener?.didLogin()
    }
    
    func signUp() {
        listener?.didSignUp()
    }
}
