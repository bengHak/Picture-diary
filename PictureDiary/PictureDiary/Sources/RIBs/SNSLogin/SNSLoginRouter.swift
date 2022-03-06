//
//  SNSLoginRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol SNSLoginInteractable: Interactable {
    var router: SNSLoginRouting? { get set }
    var listener: SNSLoginListener? { get set }
}

protocol SNSLoginViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SNSLoginRouter: ViewableRouter<SNSLoginInteractable, SNSLoginViewControllable>, SNSLoginRouting {
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SNSLoginInteractable, viewController: SNSLoginViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
