//
//  FontSettingBuilder.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs

protocol FontSettingDependency: Dependency { }

final class FontSettingComponent: Component<FontSettingDependency> { }

// MARK: - Builder

protocol FontSettingBuildable: Buildable {
    func build(withListener listener: FontSettingListener) -> FontSettingRouting
}

final class FontSettingBuilder: Builder<FontSettingDependency>, FontSettingBuildable {

    override init(dependency: FontSettingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FontSettingListener) -> FontSettingRouting {
        let component = FontSettingComponent(dependency: dependency)
        let viewController = FontSettingViewController()
        let interactor = FontSettingInteractor(presenter: viewController)
        interactor.listener = listener
        return FontSettingRouter(interactor: interactor, viewController: viewController)
    }
}
