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
    func cleanupViews()
    func attachDiaryTextField()
    func detachDiaryTextField()
    func attachDiaryDrawing()
    func detachDiaryDrawing()
}

protocol CreateDiaryPresentable: Presentable {
    var listener: CreateDiaryPresentableListener? { get set }
    func configureScrollView()
}

protocol CreateDiaryListener: AnyObject {
    func detachCreateDiary()
    func routeToVanishingCompletion()
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
    
    override func didBecomeActive() { super.didBecomeActive() }
    
    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    func tapDrawingCompleteButton() {
        listener?.detachCreateDiary()
        listener?.routeToVanishingCompletion()
    }
    
    func tapCancleButton() { listener?.detachCreateDiary() }
    
    func routeToDiaryTextField() { router?.attachDiaryTextField() }
    
    func detachDiaryTextField() {
        router?.detachDiaryTextField()
        presenter.configureScrollView()
    }
    
    func routeToDiaryDrawing() { router?.attachDiaryDrawing() }
    
    func detachDiaryDrawing() { router?.detachDiaryDrawing() }
}
