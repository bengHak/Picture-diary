//
//  SettingsBuilder.swift
//  
//
//  Created by 고병학 on 2022/08/24.
//

import RIBs

protocol SettingsDependency: Dependency { }

final class SettingsComponent: Component<SettingsDependency>,
                               FontSettingDependency,
                               NoticeDependency {
}

// MARK: - Builder

protocol SettingsBuildable: Buildable {
    func build(withListener listener: SettingsListener) -> SettingsRouting
}

final class SettingsBuilder: Builder<SettingsDependency>, SettingsBuildable {

    override init(dependency: SettingsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingsListener) -> SettingsRouting {
        let component = SettingsComponent(dependency: dependency)
        let viewController = SettingsViewController()
        let interactor = SettingsInteractor(presenter: viewController)
        interactor.listener = listener

        let font = FontSettingBuilder(dependency: component)
        let notice = NoticeBuilder(dependency: component)

        return SettingsRouter(
            interactor: interactor,
            viewController: viewController,
            fontSetting: font,
            notice: notice
        )
    }
}
