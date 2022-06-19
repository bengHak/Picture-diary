//
//  VanishingCompletionInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift

protocol VanishingCompletionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol VanishingCompletionPresentable: Presentable {
    var listener: VanishingCompletionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol VanishingCompletionListener: AnyObject {
    func detachCompletionView()
}

final class VanishingCompletionInteractor: PresentableInteractor<VanishingCompletionPresentable>,
                                           VanishingCompletionInteractable,
                                           VanishingCompletionPresentableListener {
    
    weak var router: VanishingCompletionRouting?
    weak var listener: VanishingCompletionListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: VanishingCompletionPresentable) {
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
    
    func disappearAtExpiration() {
        listener?.detachCompletionView()
    }
}
