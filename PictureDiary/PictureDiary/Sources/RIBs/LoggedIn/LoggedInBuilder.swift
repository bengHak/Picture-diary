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
                               RandomDiaryDependency,
                               SettingsDependency {

    fileprivate var splitViewController: UISplitViewController {
        return dependency.splitViewController
    }

    fileprivate var primaryViewController: UINavigationController {
        return dependency.primaryViewController
    }

    fileprivate var secondaryViewController: UINavigationController {
        return dependency.secondaryViewController
    }

    var isRefreshNeed = BehaviorRelay<Bool>(value: false)

    var diaryRepository: DiaryRepositoryProtocol = DiaryRepository()

    var pictureDiaryBehaviorRelay = BehaviorRelay<PictureDiary?>(value: nil)

    var randomPictureDiaryBehaviorRelay = BehaviorRelay<PictureDiary?>(value: nil)

    var pictureDiary: PictureDiary { pictureDiaryBehaviorRelay.value! }

    var randomPictureDiary: PictureDiary { randomPictureDiaryBehaviorRelay.value! }
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
        let randomDiary = RandomDiaryBuilder(dependency: component)
        let settings = SettingsBuilder(dependency: component)

        return LoggedInRouter(
            interactor: interactor,
            splitViewController: component.splitViewController,
            primaryViewController: component.primaryViewController,
            secondaryViewController: component.secondaryViewController,
            diaryListBuilder: diaryList,
            diaryDetailBuilder: diaryDetail,
            createDiaryBuilder: createDiary,
            randomDiaryBuilder: randomDiary,
            settingsBuilder: settings
        )
    }
}
