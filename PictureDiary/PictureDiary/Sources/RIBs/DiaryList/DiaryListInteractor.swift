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
    func fetchRandomDiary()
}

protocol DiaryListInteractorDependency {
    var diaryList: BehaviorRelay<[ModelDiaryResponse]> { get }
    var diaryRepository: DiaryRepositoryProtocol { get }
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

    init(
        presenter: DiaryListPresentable,
        dependency: DiaryListInteractorDependency
    ) {
        self.diaryList = dependency.diaryList
        self.diaryRepository = dependency.diaryRepository
        self.bag = DisposeBag()
        self.dataHelper = CoreDataHelper.shared
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchDiaryList()
        listener?.fetchRandomDiary()
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
        listener?.attachRandomDiary()
    }

    func attachSettings() {

    }
}
