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
    func showLoadingView()
    func hideLoadingView()
}

protocol DiaryListListener: AnyObject {
    func routeToCreateDiary()
    func routeToDiaryDetail(diaryId: Int)
    func attachRandomDiary()
    func fetchRandomDiary(_ completion: @escaping (Bool) -> Void)
    func attachSettings()
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
    private let initialListFetchFinished: BehaviorRelay<Bool>
    private let initialRandomDiaryFetchFinished: BehaviorRelay<Bool>
    private let bag: DisposeBag
    private let dataHelper: CDPictureDiaryHandler

    init(
        presenter: DiaryListPresentable,
        dependency: DiaryListInteractorDependency
    ) {
        self.diaryList = dependency.diaryList
        self.diaryRepository = dependency.diaryRepository
        self.initialListFetchFinished = BehaviorRelay<Bool>(value: false)
        self.initialRandomDiaryFetchFinished = BehaviorRelay<Bool>(value: false)
        self.bag = DisposeBag()
        self.dataHelper = CDPictureDiaryHandler.shared
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.showLoadingView()
        bindInitialFetch()
        fetchDiaryList()
        listener?.fetchRandomDiary { [weak self] finished in
            guard let self = self else { return }
            self.initialRandomDiaryFetchFinished.accept(finished)
        }
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
                let modified = diaryList.map { response -> ModelDiaryResponse in
                    guard let id = response.diaryId,
                          let diary = CDPictureDiaryHandler.shared.getDiaryById(id) else {
                        return response
                    }
                    var modifiedDiary = response
                    modifiedDiary.imageData = diary.drawing
                    return modifiedDiary
                }
                self.diaryList.accept(modified)
                self.initialListFetchFinished.accept(true)
            }).disposed(by: bag)
    }

    func attachDiaryDetail(diaryId: Int) {
        listener?.routeToDiaryDetail(diaryId: diaryId)
    }

    func attachRandomDiary() {
        listener?.attachRandomDiary()
    }

    func attachSettings() {
        listener?.attachSettings()
    }

    func bindInitialFetch() {
        initialListFetchFinished
            .bind(onNext: { [weak self] finished in
                guard let self = self else { return }
                if self.initialRandomDiaryFetchFinished.value && finished {
                    self.presenter.hideLoadingView()
                }
            }).disposed(by: bag)

        initialRandomDiaryFetchFinished
            .bind(onNext: { [weak self] finished in
                guard let self = self else { return }
                if self.initialListFetchFinished.value && finished {
                    self.presenter.hideLoadingView()
                }
            }).disposed(by: bag)
    }
}
