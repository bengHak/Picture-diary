//
//  SNSLoginBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol SNSLoginDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SNSLoginComponent: Component<SNSLoginDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SNSLoginBuildable: Buildable {
    func build(withListener listener: SNSLoginListener) -> SNSLoginRouting
}

final class SNSLoginBuilder: Builder<SNSLoginDependency>, SNSLoginBuildable {

    override init(dependency: SNSLoginDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SNSLoginListener) -> SNSLoginRouting {
        let _ = SNSLoginComponent(dependency: dependency)
        let viewController = SNSLoginViewController()
        let interactor = SNSLoginInteractor(presenter: viewController)
        interactor.listener = listener
        return SNSLoginRouter(interactor: interactor, viewController: viewController)
    }
}
