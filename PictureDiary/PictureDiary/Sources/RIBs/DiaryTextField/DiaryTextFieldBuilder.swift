//
//  DiaryTextFieldBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/04.
//

import RIBs
import RxRelay

protocol DiaryTextFieldDependency: Dependency {
    var diaryText: BehaviorRelay<String> { get }
}

final class DiaryTextFieldComponent: Component<DiaryTextFieldDependency> {
    fileprivate var diaryText: BehaviorRelay<String> { dependency.diaryText }
}

// MARK: - Builder

protocol DiaryTextFieldBuildable: Buildable {
    func build(withListener listener: DiaryTextFieldListener) -> DiaryTextFieldRouting
}

final class DiaryTextFieldBuilder: Builder<DiaryTextFieldDependency>, DiaryTextFieldBuildable {

    override init(dependency: DiaryTextFieldDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DiaryTextFieldListener) -> DiaryTextFieldRouting {
        let component = DiaryTextFieldComponent(dependency: dependency)
        let viewController = DiaryTextFieldViewController()
        let interactor = DiaryTextFieldInteractor(
            presenter: viewController,
            diaryText: component.diaryText
        )
        interactor.listener = listener
        return DiaryTextFieldRouter(interactor: interactor, viewController: viewController)
    }
}
