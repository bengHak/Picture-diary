//
//  NoticeBuilder.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs

protocol NoticeDependency: Dependency { }

final class NoticeComponent: Component<NoticeDependency> { }

// MARK: - Builder

protocol NoticeBuildable: Buildable {
    func build(withListener listener: NoticeListener) -> NoticeRouting
}

final class NoticeBuilder: Builder<NoticeDependency>, NoticeBuildable {

    override init(dependency: NoticeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NoticeListener) -> NoticeRouting {
        let component = NoticeComponent(dependency: dependency)
        let viewController = NoticeViewController()
        let interactor = NoticeInteractor(presenter: viewController)
        interactor.listener = listener
        return NoticeRouter(interactor: interactor, viewController: viewController)
    }
}
