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
    var splashViewController: SplashViewControllable { rootViewController }
    var loggedOutViewController: LoggedOutViewControllable { rootViewController }
    var primaryViewController: LoggedInPrimaryViewControllable { rootPrimaryViewController }
    var secondaryViewController: LoggedInSecondaryViewControllable { rootSecondaryViewController }
    
    var rootViewController: RootViewController
    let rootPrimaryViewController: LoggedInPrimaryViewControllable
    let rootSecondaryViewController: LoggedInSecondaryViewControllable
    
    init(dependency: RootDependency,
         rootViewController: RootViewController,
         rootPrimaryViewController: RootPrimaryViewController,
         rootSecondaryViewController: RootSecondaryViewController) {
        self.rootViewController = rootViewController
        self.rootPrimaryViewController = rootPrimaryViewController
        self.rootSecondaryViewController = rootSecondaryViewController
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
        let primaryVC = RootPrimaryViewController()
        let secondaryVC = RootSecondaryViewController()
        let component = RootComponent(dependency: dependency,
                                      rootViewController: viewController,
                                      rootPrimaryViewController: primaryVC,
                                      rootSecondaryViewController: secondaryVC)
        let interactor = RootInteractor(presenter: viewController)
        
        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        let splashBuilder = SplashBuilder(dependency: component)
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          primaryVC: primaryVC,
                          secondaryVC: secondaryVC,
                          loggedInBuilder: loggedInBuilder,
                          loggedOutBuilder: loggedOutBuilder,
                          splashBuilder: splashBuilder)
    }
}
