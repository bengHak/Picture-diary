//
//  DiaryListBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs
import RxRelay

protocol DiaryListDependency: Dependency {
    var isRefreshNeed: BehaviorRelay<Bool> { get }
}

final class DiaryListComponent: Component<DiaryListDependency>,
                                DiaryListInteractorDependency {
    var diaryRepository: DiaryRepositoryProtocol
    var diaryList: BehaviorRelay<[ModelDiaryResponse]>
    var isRefreshNeed: BehaviorRelay<Bool> { dependency.isRefreshNeed }
    
    override init(dependency: DiaryListDependency) {
        self.diaryRepository = DiaryRepository()
        self.diaryList = BehaviorRelay<[ModelDiaryResponse]>(value: [])
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol DiaryListBuildable: Buildable {
    func build(withListener listener: DiaryListListener) -> DiaryListRouting
}

final class DiaryListBuilder: Builder<DiaryListDependency>, DiaryListBuildable {
    
    override init(dependency: DiaryListDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: DiaryListListener) -> DiaryListRouting {
        let component = DiaryListComponent(dependency: dependency)
        let viewController = DiaryListViewController(
            diaryList: component.diaryList,
            isRefreshNeed: component.isRefreshNeed
        )
        let interactor = DiaryListInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return DiaryListRouter(interactor: interactor, viewController: viewController)
    }
}
