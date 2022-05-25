//
//  DiaryDetailBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/05/11.
//

import RIBs

protocol DiaryDetailDependency: Dependency {
    var pictureDiary: PictureDiary { get }
}

final class DiaryDetailComponent: Component<DiaryDetailDependency> {

    fileprivate var pictureDiary: PictureDiary { dependency.pictureDiary }
}

// MARK: - Builder

protocol DiaryDetailBuildable: Buildable {
    func build(withListener listener: DiaryDetailListener) -> DiaryDetailRouting
}

final class DiaryDetailBuilder: Builder<DiaryDetailDependency>, DiaryDetailBuildable {

    override init(dependency: DiaryDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DiaryDetailListener) -> DiaryDetailRouting {
        let component = DiaryDetailComponent(dependency: dependency)
        let viewController = DiaryDetailViewController(diary: component.pictureDiary)
        let interactor = DiaryDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return DiaryDetailRouter(interactor: interactor, viewController: viewController)
    }
}
