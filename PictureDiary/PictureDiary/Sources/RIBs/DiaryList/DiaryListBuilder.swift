//
//  DiaryListBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs

protocol DiaryListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DiaryListComponent: Component<DiaryListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let viewController = DiaryListViewController()
        let interactor = DiaryListInteractor(presenter: viewController)
        interactor.listener = listener
        return DiaryListRouter(interactor: interactor, viewController: viewController)
    }
}
