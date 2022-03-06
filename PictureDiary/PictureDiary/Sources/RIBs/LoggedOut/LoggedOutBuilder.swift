//
//  LoggedOutBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedOutDependency: Dependency {
    var loggedOutViewController: LoggedOutViewControllable { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency>,
                                SNSLoginDependency,
                                SignUpCompletedDependency {
    fileprivate var loggedOutViewController: LoggedOutViewControllable {
        return dependency.loggedOutViewController
    }
}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {
    
    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component = LoggedOutComponent(dependency: dependency)
        let interactor = LoggedOutInteractor()
        interactor.listener = listener
        
        let snsLogin = SNSLoginBuilder(dependency: component)
        let signupCompleted = SignUpCompletedBuilder(dependency: component)
        return LoggedOutRouter(interactor: interactor,
                               viewController: component.loggedOutViewController,
                               snsLoginBuilder: snsLogin,
                               signupCompletedBuilder: signupCompleted)
    }
}
