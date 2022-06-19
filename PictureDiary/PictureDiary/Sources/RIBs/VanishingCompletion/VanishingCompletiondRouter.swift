//
//  VanishingCompletionRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs

protocol VanishingCompletionInteractable: Interactable {
    var router: VanishingCompletionRouting? { get set }
    var listener: VanishingCompletionListener? { get set }
}

protocol VanishingCompletionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class VanishingCompletiondRouter: ViewableRouter<                                       VanishingCompletionInteractable,                                                VanishingCompletionViewControllable>, VanishingCompletionRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(
        interactor: VanishingCompletionInteractable,
        viewController: VanishingCompletionViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
