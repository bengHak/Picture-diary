//
//  DiaryListRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs

protocol DiaryListInteractable: Interactable {
    var router: DiaryListRouting? { get set }
    var listener: DiaryListListener? { get set }
}

protocol DiaryListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class DiaryListRouter: ViewableRouter<DiaryListInteractable, DiaryListViewControllable>, DiaryListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: DiaryListInteractable, viewController: DiaryListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
