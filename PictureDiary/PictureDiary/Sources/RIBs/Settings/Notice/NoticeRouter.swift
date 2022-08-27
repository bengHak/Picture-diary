//
//  NoticeRouter.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs

protocol NoticeInteractable: Interactable {
    var router: NoticeRouting? { get set }
    var listener: NoticeListener? { get set }
}

protocol NoticeViewControllable: ViewControllable { }

final class NoticeRouter: ViewableRouter<NoticeInteractable, NoticeViewControllable>, NoticeRouting {

    override init(interactor: NoticeInteractable, viewController: NoticeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
