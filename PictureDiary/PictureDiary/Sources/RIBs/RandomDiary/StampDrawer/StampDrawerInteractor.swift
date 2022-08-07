//
//  StampDrawerInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs
import RxSwift

protocol StampDrawerRouting: ViewableRouting { }

protocol StampDrawerPresentable: Presentable {
    var listener: StampDrawerPresentableListener? { get set }
}

protocol StampDrawerListener: AnyObject {
    func detachStampDrawer()
    func didTapCompleteButton()
}

final class StampDrawerInteractor: PresentableInteractor<StampDrawerPresentable>,
                                   StampDrawerInteractable,
                                   StampDrawerPresentableListener {

    weak var router: StampDrawerRouting?
    weak var listener: StampDrawerListener?

    override init(presenter: StampDrawerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func didTapCompleteButton() {
        listener?.didTapCompleteButton()
    }
}
