//
//  SNSLoginBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol SNSLoginDependency: Dependency { }

final class SNSLoginComponent: Component<SNSLoginDependency> { }

// MARK: - Builder

protocol SNSLoginBuildable: Buildable {
    func build(withListener listener: SNSLoginListener) -> SNSLoginRouting
}

final class SNSLoginBuilder: Builder<SNSLoginDependency>, SNSLoginBuildable {

    override init(dependency: SNSLoginDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SNSLoginListener) -> SNSLoginRouting {
        _ = SNSLoginComponent(dependency: dependency)
        let viewController = SNSLoginViewController()
        let authRepository = AuthRepository()
        let interactor = SNSLoginInteractor(
            presenter: viewController,
            authRepository: authRepository
        )
        interactor.listener = listener
        return SNSLoginRouter(interactor: interactor, viewController: viewController)
    }
}
