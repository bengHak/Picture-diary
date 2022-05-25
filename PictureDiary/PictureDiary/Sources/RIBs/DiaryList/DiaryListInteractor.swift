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
    func fetchDiaryList()
}

protocol DiaryListListener: AnyObject {
    func attachCreateDiary()
    func attachDiaryDetail(diary: PictureDiary)
}

final class DiaryListInteractor: PresentableInteractor<DiaryListPresentable>,
                                 DiaryListInteractable,
                                 DiaryListPresentableListener {

    weak var router: DiaryListRouting?
    weak var listener: DiaryListListener?
    private let dataHelper: CoreDataHelper

    override init(presenter: DiaryListPresentable) {
        dataHelper = CoreDataHelper.shared
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
    
    func reloadDiaryList() {
        presenter.fetchDiaryList()
    }
    
    func attachDiaryDetail(diary: PictureDiary) {
        listener?.attachDiaryDetail(diary: diary)
    }
}
