//
//  FontSettingRouter.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs

protocol FontSettingInteractable: Interactable {
    var router: FontSettingRouting? { get set }
    var listener: FontSettingListener? { get set }
}

protocol FontSettingViewControllable: ViewControllable { }

final class FontSettingRouter: ViewableRouter<FontSettingInteractable,
                               FontSettingViewControllable>,
                               FontSettingRouting {

    override init(interactor: FontSettingInteractable, viewController: FontSettingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
