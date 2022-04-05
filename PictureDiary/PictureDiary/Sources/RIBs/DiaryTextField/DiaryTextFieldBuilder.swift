//
//  DiaryTextFieldBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/04.
//

import RIBs

protocol DiaryTextFieldDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DiaryTextFieldComponent: Component<DiaryTextFieldDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = DiaryTextFieldInteractor(presenter: viewController)
        interactor.listener = listener
        return DiaryTextFieldRouter(interactor: interactor, viewController: viewController)
    }
}
