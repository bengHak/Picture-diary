//
//  DiaryDrawingBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs

protocol DiaryDrawingDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DiaryDrawingComponent: Component<DiaryDrawingDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol DiaryDrawingBuildable: Buildable {
    func build(withListener listener: DiaryDrawingListener) -> DiaryDrawingRouting
}

final class DiaryDrawingBuilder: Builder<DiaryDrawingDependency>, DiaryDrawingBuildable {

    override init(dependency: DiaryDrawingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DiaryDrawingListener) -> DiaryDrawingRouting {
        let component = DiaryDrawingComponent(dependency: dependency)
        let viewController = DiaryDrawingViewController()
        let interactor = DiaryDrawingInteractor(presenter: viewController)
        interactor.listener = listener
        return DiaryDrawingRouter(interactor: interactor, viewController: viewController)
    }
}
