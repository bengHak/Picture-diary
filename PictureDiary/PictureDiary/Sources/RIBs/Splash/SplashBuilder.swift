//
//  SplashBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol SplashDependency: Dependency { }

final class SplashComponent: Component<SplashDependency> { }

// MARK: - Builder

protocol SplashBuildable: Buildable {
    func build(withListener listener: SplashListener) -> SplashRouting
}

final class SplashBuilder: Builder<SplashDependency>, SplashBuildable {

    override init(dependency: SplashDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SplashListener) -> SplashRouting {
        _ = SplashComponent(dependency: dependency)
        let viewController = SplashViewController()
        let interactor = SplashInteractor(presenter: viewController)
        interactor.listener = listener
        return SplashRouter(interactor: interactor, viewController: viewController)
    }
}
