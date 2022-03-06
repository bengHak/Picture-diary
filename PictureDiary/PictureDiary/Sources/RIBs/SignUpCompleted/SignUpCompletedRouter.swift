//
//  SignUpCompletedRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol SignUpCompletedInteractable: Interactable {
    var router: SignUpCompletedRouting? { get set }
    var listener: SignUpCompletedListener? { get set }
}

protocol SignUpCompletedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SignUpCompletedRouter: ViewableRouter<SignUpCompletedInteractable, SignUpCompletedViewControllable>, SignUpCompletedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SignUpCompletedInteractable, viewController: SignUpCompletedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
