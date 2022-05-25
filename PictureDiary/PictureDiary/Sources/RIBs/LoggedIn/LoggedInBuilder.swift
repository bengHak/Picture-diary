//
//  LoggedInBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs
import RxRelay

protocol LoggedInDependency: Dependency {
    var rootSplitViewController: LoggedInSplitViewControllable { get }
    var primaryViewController: LoggedInPrimaryViewControllable { get }
    var secondaryViewController: LoggedInSecondaryViewControllable { get }
}

final class LoggedInComponent: Component<LoggedInDependency>,
                               DiaryListDependency,
                               DiaryDetailDependency,
                               CreateDiaryDependency,
                               LoggedInInteractorDependency {
    fileprivate var rootSplitViewController: LoggedInSplitViewControllable {
        return dependency.rootSplitViewController
    }
    
    fileprivate var primaryVieController: LoggedInPrimaryViewControllable {
        return dependency.primaryViewController
    }
    
    fileprivate var secondaryViewController: LoggedInSecondaryViewControllable {
        return dependency.secondaryViewController
    }
    
    var pictureDiaryBehaviorRelay = BehaviorRelay<PictureDiary?>(value: nil)

    var pictureDiary: PictureDiary { pictureDiaryBehaviorRelay.value! }
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
        let interactor = LoggedInInteractor(dependency: component)
        interactor.listener = listener
        
        let diaryList = DiaryListBuilder(dependency: component)
        let diaryDetail = DiaryDetailBuilder(dependency: component)
        let createDiary = CreateDiaryBuilder(dependency: component)
        return LoggedInRouter(interactor: interactor,
                              splitViewController: component.rootSplitViewController,
                              primaryViewController: component.primaryVieController,
                              secondaryViewController: component.secondaryViewController,
                              diaryListBuilder: diaryList,
                              diaryDetailBuilder: diaryDetail,
                              createDiaryBuilder: createDiary)
    }
}
