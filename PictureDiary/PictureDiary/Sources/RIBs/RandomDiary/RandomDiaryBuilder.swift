//
//  RandomDiaryBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs
import RxRelay

protocol RandomDiaryDependency: Dependency {
    var pictureDiary: PictureDiary { get }
}

final class RandomDiaryComponent: Component<RandomDiaryDependency>,
                                  DiaryDetailDependency,
                                  StampDrawerDependency,
                                  RandomDiaryInteractorDependency {
    var pictureDiary: PictureDiary { dependency.pictureDiary }
    let diaryRepository: DiaryRepositoryProtocol
    let selectedStamp: BehaviorRelay<StampType?>
    let stampPosition: BehaviorRelay<StampPosition>

    override init(dependency: RandomDiaryDependency) {
        self.diaryRepository = DiaryRepository()
        self.selectedStamp = BehaviorRelay<StampType?>(value: nil)
        self.stampPosition = BehaviorRelay<StampPosition>(value: StampPosition(x: 0, y: 0))
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RandomDiaryBuildable: Buildable {
    func build(withListener listener: RandomDiaryListener) -> RandomDiaryRouting
}

final class RandomDiaryBuilder: Builder<RandomDiaryDependency>, RandomDiaryBuildable {

    override init(dependency: RandomDiaryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RandomDiaryListener) -> RandomDiaryRouting {
        let component = RandomDiaryComponent(dependency: dependency)
        let viewController = RandomDiaryViewController(
            selectedStamp: component.selectedStamp,
            stampPosition: component.stampPosition
        )
        let interactor = RandomDiaryInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener

        let diaryDetail = DiaryDetailBuilder(dependency: component)
        let stampDrawer = StampDrawerBuilder(dependency: component)

        return RandomDiaryRouter(
            interactor: interactor,
            viewController: viewController,
            diaryDetail: diaryDetail,
            stampDrawer: stampDrawer
        )
    }
}
