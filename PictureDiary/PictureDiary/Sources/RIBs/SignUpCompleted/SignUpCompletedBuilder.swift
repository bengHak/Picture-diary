//
//  SignUpCompletedBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol SignUpCompletedDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SignUpCompletedComponent: Component<SignUpCompletedDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SignUpCompletedBuildable: Buildable {
    func build(withListener listener: SignUpCompletedListener) -> SignUpCompletedRouting
}

final class SignUpCompletedBuilder: Builder<SignUpCompletedDependency>, SignUpCompletedBuildable {

    override init(dependency: SignUpCompletedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SignUpCompletedListener) -> SignUpCompletedRouting {
        let component = SignUpCompletedComponent(dependency: dependency)
        let viewController = SignUpCompletedViewController()
        let interactor = SignUpCompletedInteractor(presenter: viewController)
        interactor.listener = listener
        return SignUpCompletedRouter(interactor: interactor, viewController: viewController)
    }
}
