//
//  DiaryListInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs
import RxSwift
import RxRelay

protocol DiaryListRouting: ViewableRouting { }

protocol DiaryListPresentable: Presentable {
    var listener: DiaryListPresentableListener? { get set }
}

protocol DiaryListListener: AnyObject {
    func routeToCreateDiary()
    func routeToDiaryDetail(diaryId: Int)
    func attachRandomDiary()
}

protocol DiaryListInteractorDependency {
    var diaryList: BehaviorRelay<[ModelDiaryResponse]> { get }
    var diaryRepository: DiaryRepositoryProtocol { get }
    var randomPictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?> { get }
}

final class DiaryListInteractor: PresentableInteractor<DiaryListPresentable>,
                                 DiaryListInteractable,
                                 DiaryListPresentableListener {

    weak var router: DiaryListRouting?
    weak var listener: DiaryListListener?
    private let diaryList: BehaviorRelay<[ModelDiaryResponse]>
    private let diaryRepository: DiaryRepositoryProtocol
    private let bag: DisposeBag
    private let dataHelper: CoreDataHelper
    private let randomPictureDiaryBehaviorRelay: BehaviorRelay<PictureDiary?>

    init(
        presenter: DiaryListPresentable,
        dependency: DiaryListInteractorDependency
    ) {
        self.diaryList = dependency.diaryList
        self.diaryRepository = dependency.diaryRepository
        self.bag = DisposeBag()
        self.dataHelper = CoreDataHelper.shared
        self.randomPictureDiaryBehaviorRelay = dependency.randomPictureDiaryBehaviorRelay
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchDiaryList()
        fetchRandomDiary()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func attachCreateDiary() {
        listener?.routeToCreateDiary()
    }

    func fetchDiaryList() {
        diaryRepository.fetchDiaryList()
            .subscribe(onNext: { [weak self] diaryList in
                guard let self = self else { return }
                var modified = diaryList
                modified = modified.map { response -> ModelDiaryResponse in
                    guard let id = response.diaryId,
                          let diary = CoreDataHelper.shared.getDiaryById(id) else {
                        return response
                    }
                    var modifiedDiary = response
                    modifiedDiary.imageData = diary.drawing
                    return modifiedDiary
                }
                self.diaryList.accept(modified)
            }).disposed(by: bag)
    }

    func attachDiaryDetail(diaryId: Int) {
        listener?.routeToDiaryDetail(diaryId: diaryId)
    }

    func attachRandomDiary() {
        if randomPictureDiaryBehaviorRelay.value != nil {
            self.listener?.attachRandomDiary()
            return
        }

        randomPictureDiaryBehaviorRelay
            .bind(onNext: { [weak self] pictureDiary in
                guard let self = self,
                    pictureDiary != nil else {
                    return
                }
                self.attachRandomDiary()
            }).disposed(by: bag)
        fetchRandomDiary()
    }

    func fetchRandomDiary() {
        diaryRepository.fetchRandomDiary()
            .subscribe(onNext: { [weak self] diaryResponse in
                guard let self = self,
                      let imageData = try? Data(contentsOf: URL(string: diaryResponse.imageUrl!)!)  else {
                          return
                      }
                if let diary = CoreDataHelper.shared.getDiaryById(-1) {
                    if diary.imageUrl == diaryResponse.imageUrl {
                        diary.drawing = imageData
                        self.randomPictureDiaryBehaviorRelay.accept(diary)
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
                        self.randomPictureDiaryBehaviorRelay.accept(diary)
                    } else {
                        print("🔴 랜덤 일기 캐싱 실패")
                    }
                }
            }).disposed(by: self.bag)
    }

    func attachSettings() {

    }
}
