//
//  CreateDiaryInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxSwift

protocol CreateDiaryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CreateDiaryPresentable: Presentable {
    var listener: CreateDiaryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CreateDiaryListener: AnyObject {
    func detachCreateDiary()
}

final class CreateDiaryInteractor: PresentableInteractor<CreateDiaryPresentable>,
                                   CreateDiaryInteractable,
                                   CreateDiaryPresentableListener {
    
    weak var router: CreateDiaryRouting?
    weak var listener: CreateDiaryListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CreateDiaryPresentable) {
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
    
    func detachCreateDiary() {
        listener?.detachCreateDiary()
    }
}
