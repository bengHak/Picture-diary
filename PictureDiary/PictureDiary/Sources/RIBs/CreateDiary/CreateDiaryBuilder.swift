//
//  CreateDiaryBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs

protocol CreateDiaryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateDiaryComponent: Component<CreateDiaryDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CreateDiaryBuildable: Buildable {
    func build(withListener listener: CreateDiaryListener) -> CreateDiaryRouting
}

final class CreateDiaryBuilder: Builder<CreateDiaryDependency>, CreateDiaryBuildable {

    override init(dependency: CreateDiaryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateDiaryListener) -> CreateDiaryRouting {
        let component = CreateDiaryComponent(dependency: dependency)
        let viewController = CreateDiaryViewController()
        let interactor = CreateDiaryInteractor(presenter: viewController)
        interactor.listener = listener
        return CreateDiaryRouter(interactor: interactor, viewController: viewController)
    }
}