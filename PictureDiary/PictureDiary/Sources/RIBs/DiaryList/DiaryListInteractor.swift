//
//  DiaryListInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs
import RxSwift

protocol DiaryListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DiaryListPresentable: Presentable {
    var listener: DiaryListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DiaryListListener: AnyObject {
    func attachCreateDiary()
}

final class DiaryListInteractor: PresentableInteractor<DiaryListPresentable>, DiaryListInteractable, DiaryListPresentableListener {

    weak var router: DiaryListRouting?
    weak var listener: DiaryListListener?

    override init(presenter: DiaryListPresentable) {
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
    
    func attachCreateDiary() {
        listener?.attachCreateDiary()
    }
}
