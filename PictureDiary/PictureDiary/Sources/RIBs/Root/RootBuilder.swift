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
    var primaryViewController: UINavigationController { rootPrimaryViewController }
    var secondaryViewController: UINavigationController { rootSecondaryViewController }

    private let rootViewController: RootViewController
    private let rootSplitViewController: UISplitViewController
    private let rootPrimaryViewController: UINavigationController
    private let rootSecondaryViewController: UINavigationController

    init(
        dependency: RootDependency,
        rootViewController: RootViewController,
        rootSplitViewController: UISplitViewController,
        rootPrimaryViewController: UINavigationController,
        rootSecondaryViewController: UINavigationController
    ) {
        self.rootViewController = rootViewController
        self.rootSplitViewController = rootSplitViewController
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
        let splitVC: RootSplitViewController
        if #available(iOS 14.0, *) {
            splitVC = RootSplitViewController(style: .doubleColumn)
        } else {
            splitVC = RootSplitViewController()
        }
        let primaryVC = UINavigationController(rootViewController: RootPrimaryViewController())
        let secondaryVC = UINavigationController(rootViewController: RootSecondaryViewController())
        let component = RootComponent(
            dependency: dependency,
            rootViewController: viewController,
            rootSplitViewController: splitVC,
            rootPrimaryViewController: primaryVC,
            rootSecondaryViewController: secondaryVC
        )
        let interactor = RootInteractor(presenter: viewController)

        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        let splashBuilder = SplashBuilder(dependency: component)

        return RootRouter(
            interactor: interactor,
            viewController: viewController,
            splitVC: splitVC,
            primaryVC: primaryVC,
            secondaryVC: secondaryVC,
            loggedInBuilder: loggedInBuilder,
            loggedOutBuilder: loggedOutBuilder,
            splashBuilder: splashBuilder
        )
    }
}
