//
//  DiaryDrawingInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs
import RxSwift

protocol DiaryDrawingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DiaryDrawingPresentable: Presentable {
    var listener: DiaryDrawingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DiaryDrawingListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class DiaryDrawingInteractor: PresentableInteractor<DiaryDrawingPresentable>, DiaryDrawingInteractable, DiaryDrawingPresentableListener {

    weak var router: DiaryDrawingRouting?
    weak var listener: DiaryDrawingListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: DiaryDrawingPresentable) {
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
}
