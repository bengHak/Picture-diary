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
    func attachRandomDiary()
    func detachRandomDiary()
}

protocol LoggedInListener: AnyObject { }

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
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }

    // MARK: - CreateDiary
    func detachCreateDiary() { router?.detachCreateDiary() }

    func setRefreshNeed() { self.isRefreshNeed.accept(true) }
    
    // MARK: - DiaryDetail
    func detachDiaryDetail() { router?.detachDiaryDetail() }

    // MARK: - DiaryList
    func routeToCreateDiary() { router?.attachCreateDiary() }

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

    func attachRandomDiary() {
        self.diaryRepository.fetchRandomDiary()
            .subscribe(onNext: { [weak self] diaryResponse in
                guard let self = self,
                      let imageData = try? Data(contentsOf: URL(string: diaryResponse.imageUrl!)!)  else {
                          return
                      }
                if let diary = CoreDataHelper.shared.getDiaryById(-1) {
                    if diary.imageUrl == diaryResponse.imageUrl {
                        diary.drawing = imageData
                        self.pictureDiaryBehaviorRelay.accept(diary)
                        self.router?.attachRandomDiary()
                        return
                    } else {
                        CoreDataHelper.shared.removeCachedDiary(diary)
                    }
                }

                CoreDataHelper.shared.saveDiary(
                    id: -1,
                    date: diaryResponse.getDate(),
                    weather: diaryResponse.getWeather(),
                    drawing: imageData,
                    content: diaryResponse.content!,
                    imageUrl: diaryResponse.imageUrl!
                ) { diary, success in
                    if success {
                        self.pictureDiaryBehaviorRelay.accept(diary)
                        self.router?.attachRandomDiary()
                    } else {
                        print("🔴 랜덤 일기 캐싱 실패")
                    }
                }
            }).disposed(by: self.bag)
    }

    // MARK: - RandomDiary
    func detachRandomDiary() {
        router?.detachRandomDiary()
    }

}
