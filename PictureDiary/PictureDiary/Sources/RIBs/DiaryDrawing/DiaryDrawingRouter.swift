//
//  DiaryDrawingRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs

protocol DiaryDrawingInteractable: Interactable {
    var router: DiaryDrawingRouting? { get set }
    var listener: DiaryDrawingListener? { get set }
}

protocol DiaryDrawingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class DiaryDrawingRouter: ViewableRouter<DiaryDrawingInteractable, DiaryDrawingViewControllable>, DiaryDrawingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: DiaryDrawingInteractable, viewController: DiaryDrawingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
