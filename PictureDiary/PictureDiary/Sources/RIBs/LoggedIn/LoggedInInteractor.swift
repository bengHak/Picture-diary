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
    var randomPictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?> { get }
    var diaryRepository: DiaryRepositoryProtocol { get }
    var isRefreshNeed: BehaviorRelay<Bool> { get }
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?
    private let diaryRepository: DiaryRepositoryProtocol
    private let pictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?>
    private let randomPictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?>
    private let isRefreshNeed: BehaviorRelay<Bool>
    private let bag: DisposeBag

    init(dependency: LoggedInInteractorDependency) {
        self.diaryRepository = dependency.diaryRepository
        self.pictureDiaryBehaviorRelay = dependency.pictureDiaryBehaviorRelay
        self.randomPictureDiaryBehaviorRelay = dependency.randomPictureDiaryBehaviorRelay
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
                if let diary = CDPictureDiaryHandler.shared.getDiaryById(diaryId) {
                    diary.content = diaryResponse.content
                    diary.stampList = diaryResponse.stampList ?? []
                    self.pictureDiaryBehaviorRelay.accept(diary)
                    self.router?.attachDiaryDetail()
                } else {
                    print("🔴 failed to fetch diary")
                }
            })
            .disposed(by: self.bag)
    }

    // MARK: - RandomDiary
    func attachRandomDiary() {
        if randomPictureDiaryBehaviorRelay.value != nil {
            router?.attachRandomDiary()
            return
        }

        randomPictureDiaryBehaviorRelay
            .bind(onNext: { [weak self] pictureDiary in
                guard let self = self,
                    pictureDiary != nil else {
                    return
                }
                self.attachRandomDiary()
            }).disposed(by: self.bag)
        fetchRandomDiary()
    }

    func detachRandomDiary() {
        router?.detachRandomDiary()
    }

    func refreshRandomDiary() {
        if let cachedDiary = CDPictureDiaryHandler.shared.getCachedRandomDiary(),
           let diary = self.randomPictureDiaryBehaviorRelay.value,
           cachedDiary.imageUrl == diary.imageUrl {
            self.randomPictureDiaryBehaviorRelay.accept(cachedDiary)
            return
        }
    }

    func fetchRandomDiary() {
        diaryRepository.fetchRandomDiary()
            .subscribe(onNext: { [weak self] diaryResponse in
                guard let self = self,
                      let imageData = try? Data(contentsOf: URL(string: diaryResponse.imageUrl!)!)  else {
                          return
                      }

                if let diary = CDPictureDiaryHandler.shared.getCachedRandomDiary() {
                    if diary.imageUrl == diaryResponse.imageUrl,
                       diary.didStamp == diaryResponse.stamped ?? false {
                        diary.drawing = imageData
                        self.randomPictureDiaryBehaviorRelay.accept(diary)
                        return
                    } else {
                        CDPictureDiaryHandler.shared.removeCachedDiary(diary)
                    }
                }

                CDPictureDiaryHandler.shared.saveDiary(
                    diaryResponse: diaryResponse,
                    drawing: imageData,
                    isRandomDiary: true
                ) { diary, success in
                    if success {
                        self.randomPictureDiaryBehaviorRelay.accept(diary)
                    } else {
                        print("🔴 랜덤 일기 캐싱 실패")
                    }
                }
            }).disposed(by: self.bag)
    }
}
