//
//  RootBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/04.
//

import RIBs

protocol RootDependency: Dependency { }

final class RootComponent: Component<RootDependency>,
                           LoggedOutDependency,
                           LoggedInDependency,
                           SplashDependency {
    var loggedOutViewController: LoggedOutViewControllable { rootViewController }
    var loggedInViewController: LoggedInViewControllable { rootViewController }
    var splashViewController: SplashViewControllable { rootViewController }
    let rootViewController: RootViewController
    
    init(dependency: RootDependency,
         rootViewController: RootViewController) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let component = RootComponent(dependency: dependency,
                                      rootViewController: viewController)
        let interactor = RootInteractor(presenter: viewController)
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        let splashBuilder = SplashBuilder(dependency: component)
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          loggedInBuilder: loggedInBuilder,
                          loggedOutBuilder: loggedOutBuilder,
                          splashBuilder: splashBuilder)
    }
}
