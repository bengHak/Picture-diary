//
//  DiaryTextFieldRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/04.
//

import RIBs

protocol DiaryTextFieldInteractable: Interactable {
    var router: DiaryTextFieldRouting? { get set }
    var listener: DiaryTextFieldListener? { get set }
}

protocol DiaryTextFieldViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class DiaryTextFieldRouter: ViewableRouter<DiaryTextFieldInteractable, DiaryTextFieldViewControllable>, DiaryTextFieldRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: DiaryTextFieldInteractable, viewController: DiaryTextFieldViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
