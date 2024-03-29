//
//  DiaryDetailRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/05/11.
//

import RIBs

protocol DiaryDetailInteractable: Interactable {
    var router: DiaryDetailRouting? { get set }
    var listener: DiaryDetailListener? { get set }
}

protocol DiaryDetailViewControllable: ViewControllable { }

final class DiaryDetailRouter: ViewableRouter<DiaryDetailInteractable, DiaryDetailViewControllable>,
                               DiaryDetailRouting {
    override init(interactor: DiaryDetailInteractable, viewController: DiaryDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
