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
    var splitViewController: UISplitViewController { rootSplitViewController }

    private let rootViewController: RootViewController
    private let rootSplitViewController: UISplitViewController

    init(
        dependency: RootDependency,
        rootViewController: RootViewController,
        rootSplitViewController: UISplitViewController
    ) {
        self.rootViewController = rootViewController
        self.rootSplitViewController = rootSplitViewController
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
        let splitVC: RootSplitViewController
        let primaryVC = RootPrimaryViewController()
        let secondaryVC = RootSecondaryViewController()
        if #available(iOS 14.0, *) {
            splitVC = RootSplitViewController(style: .doubleColumn)
            splitVC.setViewController(primaryVC, for: .primary)
            splitVC.setViewController(secondaryVC, for: .secondary)
        } else {
            splitVC = RootSplitViewController()
            splitVC.viewControllers = [primaryVC, secondaryVC]
        }

        let component = RootComponent(
            dependency: dependency,
            rootViewController: viewController,
            rootSplitViewController: splitVC
        )
        let interactor = RootInteractor(presenter: viewController)

        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        let splashBuilder = SplashBuilder(dependency: component)

        return RootRouter(
            interactor: interactor,
            viewController: viewController,
            splitVC: splitVC,
            loggedInBuilder: loggedInBuilder,
            loggedOutBuilder: loggedOutBuilder,
            splashBuilder: splashBuilder
        )
    }
}
