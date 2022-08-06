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
    private let diaryRepository: DiaryRepositoryProtocol

    init(
        presenter: RandomDiaryPresentable,
        dependency: RandomDiaryInteractorDependency
    ) {
        self.diary = dependency.pictureDiary
        self.selectedStamp = dependency.selectedStamp
        self.stampPosition = dependency.stampPosition
        self.diaryRepository = dependency.diaryRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachDiaryDetail()
        if !diary.didStamp {
            router?.attachStampDrawer()
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

    func tapCompleteButton() {
        guard let stamp = selectedStamp.value else {
            return
        }
        let posX = stampPosition.value.x
        let posY = stampPosition.value.y

//        print("🚧 stamp position: \(x), \(y)")

//        diaryRepository.postStamp(diaryId: diary.id, stampType: stamp, posX: x, posY: y)
    }
}
