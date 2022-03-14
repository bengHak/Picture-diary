//
//  CreateDiaryRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs

protocol CreateDiaryInteractable: Interactable {
    var router: CreateDiaryRouting? { get set }
    var listener: CreateDiaryListener? { get set }
}

protocol CreateDiaryViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateDiaryRouter: ViewableRouter<CreateDiaryInteractable, CreateDiaryViewControllable>, CreateDiaryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateDiaryInteractable, viewController: CreateDiaryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
