//
//  RandomDiaryInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs
import RxSwift
import RxRelay

protocol RandomDiaryRouting: ViewableRouting {
    func attachDiaryDetail()
    func detachDiaryDetail()
    func attachStampDrawer()
    func detachStampDrawer()
    func cleanUpViews()
}

protocol RandomDiaryPresentable: Presentable {
    var listener: RandomDiaryPresentableListener? { get set }

    func detachDetailView()
    func detachStampDrawer()
}

protocol RandomDiaryListener: AnyObject {
    func detachRandomDiary()
    func fetchRandomDiary()
}

protocol RandomDiaryInteractorDependency {
    var pictureDiary: PictureDiary { get }
    var selectedStamp: BehaviorRelay<StampType?> { get }
    var stampPosition: BehaviorRelay<StampPosition> { get }
    var diaryRepository: DiaryRepositoryProtocol { get }
}

final class RandomDiaryInteractor: PresentableInteractor<RandomDiaryPresentable>,
                                   RandomDiaryInteractable,
                                   RandomDiaryPresentableListener {

    weak var router: RandomDiaryRouting?
    weak var listener: RandomDiaryListener?

    private let diary: PictureDiary
    private let stampPosition: BehaviorRelay<StampPosition>
    private let selectedStamp: BehaviorRelay<StampType?>
    private let postResult: BehaviorRelay<CommonResponse?>
    private let diaryRepository: DiaryRepositoryProtocol
    private let bag: DisposeBag

    init(
        presenter: RandomDiaryPresentable,
        dependency: RandomDiaryInteractorDependency
    ) {
        self.diary = dependency.pictureDiary
        self.selectedStamp = dependency.selectedStamp
        self.stampPosition = dependency.stampPosition
        self.postResult = BehaviorRelay<CommonResponse?>(value: nil)
        self.diaryRepository = dependency.diaryRepository
        self.bag = DisposeBag()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachDiaryDetail()
        if !diary.didStamp {
            router?.attachStampDrawer()
            bindPostStampResult()
        }
    }

    override func willResignActive() {
        super.willResignActive()
        detachDiaryDetail()
        detachStampDrawer()
        router?.cleanUpViews()
    }

    func detachDiaryDetail() {
        presenter.detachDetailView()
    }

    func detachStampDrawer() {
        presenter.detachStampDrawer()
    }

    func didTapBackButton() {
        listener?.detachRandomDiary()
    }

    func didTapCompleteButton() {
        guard let stamp = selectedStamp.value,
              let posX = stampPosition.value.proportionalX,
              let posY = stampPosition.value.proportionalY else {
            return
        }

        print("🚧 stamp position: \(posX), \(posY), \(stamp.rawValue)")

        diaryRepository.postStamp(
            diaryId: diary.id,
            stampType: stamp,
            posX: posX,
            posY: posY
        ).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.postResult.accept(response)
        }).disposed(by: bag)
    }

    func bindPostStampResult() {
        postResult
            .subscribe(onNext: { [weak self] response in
                guard let self = self,
                      let msg = response?.responseMessage else {
                    return
                }
                if msg == ResponseMessage.postStampSuccess.rawValue {
                    // 도장 찍기에 성공했을 때
                    // 내가 도장찍은 Diary 데이터를 다시 가져와서 randomDiary 값과 치환한다.
                    self.listener?.fetchRandomDiary()
                    self.router?.detachStampDrawer()
                }
            }).disposed(by: bag)
    }
}
