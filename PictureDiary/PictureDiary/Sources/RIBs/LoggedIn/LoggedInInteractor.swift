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
    func attachDirayListAtPrimary()
    func detachDiaryList()
    func attachCreateDiary()
    func detachCreateDiary()
    func attachDiaryDetail()
    func detachDiaryDetail()
}

protocol LoggedInListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol LoggedInInteractorDependency {
    var pictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?> { get }
    var diaryRepository: DiaryRepositoryProtocol { get }
    var isRefreshNeed: BehaviorRelay<Bool> { get }
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {
    
    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?
    private let diaryRepository: DiaryRepositoryProtocol
    private let pictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?>
    private let isRefreshNeed: BehaviorRelay<Bool>
    private let bag: DisposeBag
    
    init(dependency: LoggedInInteractorDependency) {
        self.diaryRepository = dependency.diaryRepository
        self.pictureDiaryBehaviorRelay = dependency.pictureDiaryBehaviorRelay
        self.isRefreshNeed = dependency.isRefreshNeed
        self.bag = DisposeBag()
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
    
    func setRefreshNeed() { self.isRefreshNeed.accept(true) }
    
    func routeToDiaryDetail(diaryId: Int) {
        self.diaryRepository.fetchDiary(id: diaryId)
            .subscribe(onNext: { [weak self] diaryResponse in
                guard let self = self else { return }
                if let diary = CoreDataHelper.shared.getDiaryById(diaryId) {
                    diary.content = diaryResponse.content
                    self.pictureDiaryBehaviorRelay.accept(diary)
                    self.router?.attachDiaryDetail()
                } else {
                    print("🔴 failed to fetch diary")
                }
            })
            .disposed(by: self.bag)
    }
    
    func detachDiaryDetail() { router?.detachDiaryDetail() }
}
