//
//  LoggedInBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import RIBs
import RxRelay

protocol LoggedInDependency: Dependency {
    var splitViewController: UISplitViewController { get }
    var primaryViewController: UINavigationController { get }
    var secondaryViewController: UINavigationController { get }
}

final class LoggedInComponent: Component<LoggedInDependency>,
                               DiaryListDependency,
                               DiaryDetailDependency,
                               CreateDiaryDependency,
                               LoggedInInteractorDependency,
                               VanishingCompletionDependency {
    fileprivate var splitViewController: UISplitViewController {
        return dependency.splitViewController
    }
    
    fileprivate var primaryVieController: UINavigationController {
        return dependency.primaryViewController
    }
    
    fileprivate var secondaryViewController: UINavigationController {
        return dependency.secondaryViewController
    }
    
    var pictureDiaryBehaviorRelay = BehaviorRelay<PictureDiary?>(value: nil)

    var pictureDiary: PictureDiary { pictureDiaryBehaviorRelay.value! }
    
    var labelText: String { "오늘의 일기가 저장되었어요!" }
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
        let vanishingCompletion = VanishingCompletionBuilder(dependency: component)
        return LoggedInRouter(interactor: interactor,
                              splitViewController: component.splitViewController,
                              primaryViewController: component.primaryVieController,
                              secondaryViewController: component.secondaryViewController,
                              diaryListBuilder: diaryList,
                              diaryDetailBuilder: diaryDetail,
                              createDiaryBuilder: createDiary,
                              vanishingCompletionBuilder: vanishingCompletion)
    }
}
