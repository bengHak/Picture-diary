//
//  VanishingCompletionBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol VanishingCompletionDependency: Dependency {
    var labelText: String { get }
}

final class VanishingCompletionComponent: Component<VanishingCompletionDependency> {
    fileprivate var labelText: String { dependency.labelText }
}

// MARK: - Builder

protocol VanishingCompletionBuildable: Buildable {
    func build(withListener listener: VanishingCompletionListener) -> VanishingCompletionRouting
}

final class VanishingCompletionBuilder: Builder<VanishingCompletionDependency>, VanishingCompletionBuildable {

    override init(dependency: VanishingCompletionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: VanishingCompletionListener) -> VanishingCompletionRouting {
        let component = VanishingCompletionComponent(dependency: dependency)
        let viewController = VanishingCompletionViewController(component.labelText)
        let interactor = VanishingCompletionInteractor(presenter: viewController)
        interactor.listener = listener
        return VanishingCompletiondRouter(interactor: interactor, viewController: viewController)
    }
}
