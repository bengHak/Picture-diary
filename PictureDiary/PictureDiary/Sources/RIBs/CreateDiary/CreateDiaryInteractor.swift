//
//  CreateDiaryInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxSwift
import RxRelay

protocol CreateDiaryRouting: ViewableRouting {
    func routeToDiaryTextField()
    func detachDiaryTextField()
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
    var diaryText: BehaviorRelay<String>
    
    override init(presenter: CreateDiaryPresentable) {
        diaryText = BehaviorRelay<String>(value: "")
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
    
    func attachDiaryTextField() {
        router?.routeToDiaryTextField()
    }
    
    func detachDiaryTextField() {
        router?.detachDiaryTextField()
    }
}
