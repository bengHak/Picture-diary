//
//  LoggedInBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs

protocol LoggedInDependency: Dependency {
    var primaryViewController: LoggedInPrimaryViewControllable { get }
    var secondaryViewController: LoggedInSecondaryViewControllable { get }
}

final class LoggedInComponent: Component<LoggedInDependency>,
                               DiaryListDependency,
                               CreateDiaryDependency {
    fileprivate var primaryVieController: LoggedInPrimaryViewControllable {
        return dependency.primaryViewController
    }
    
    fileprivate var secondaryViewController: LoggedInSecondaryViewControllable {
        return dependency.secondaryViewController
    }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener) -> LoggedInRouting
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency)
        let interactor = LoggedInInteractor()
        interactor.listener = listener
        
        let diaryList = DiaryListBuilder(dependency: component)
        let createDiary = CreateDiaryBuilder(dependency: component)
        return LoggedInRouter(interactor: interactor,
                              primaryViewController: component.primaryVieController,
                              secondaryViewController: component.secondaryViewController,
                              diaryListBuilder: diaryList,
                              createDiaryBuilder: createDiary)
    }
}
