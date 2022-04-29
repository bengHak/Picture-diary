//
//  DiaryDrawingInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs
import RxSwift

protocol DiaryDrawingRouting: ViewableRouting { }

protocol DiaryDrawingPresentable: Presentable {
    var listener: DiaryDrawingPresentableListener? { get set }
}

protocol DiaryDrawingListener: AnyObject {
    func detachDiaryDrawing()
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
    
    func detachDiaryDrawing() {
        listener?.detachDiaryDrawing()
    }
}
