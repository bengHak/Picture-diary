//
//  StampDrawerRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs

protocol StampDrawerInteractable: Interactable {
    var router: StampDrawerRouting? { get set }
    var listener: StampDrawerListener? { get set }
}

protocol StampDrawerViewControllable: ViewControllable { }

final class StampDrawerRouter: ViewableRouter<StampDrawerInteractable,
                               StampDrawerViewControllable>,
                               StampDrawerRouting {

    override init(interactor: StampDrawerInteractable, viewController: StampDrawerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
