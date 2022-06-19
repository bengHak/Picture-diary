//
//  LoggedInInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs
import RxSwift
import RxRelay

protocol LoggedInRouting: Routing {
    func cleanupViews()
    func attachCreateDiary()
    func detachCreateDiary()
    func attachDiaryDetail()
    func detachDiaryDetail()
    func attachVanishingCompletion()
    func detachVanishingCompletion()
}

protocol LoggedInListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol LoggedInInteractorDependency {
    var pictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?> { get }
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?
    private let pictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?>

    init(dependency: LoggedInInteractorDependency) {
        self.pictureDiaryBehaviorRelay = dependency.pictureDiaryBehaviorRelay
        super.init()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    func routeToCreateDiary() { router?.attachCreateDiary() }
    
    func detachCreateDiary() { router?.detachCreateDiary() }
    
    func routeToDiaryDetail(diary: PictureDiary) {
        pictureDiaryBehaviorRelay.accept(diary)
        router?.attachDiaryDetail()
    }
    
    func detachDiaryDetail() { router?.detachDiaryDetail() }
    
    func routeToVanishingCompletion() { router?.attachVanishingCompletion() }
    
    func detachCompletionView() { router?.detachVanishingCompletion() }
}
