//
//  VanishingCompletionInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift

protocol VanishingCompletionRouting: ViewableRouting { }

protocol VanishingCompletionPresentable: Presentable {
    var listener: VanishingCompletionPresentableListener? { get set }
}

protocol VanishingCompletionListener: AnyObject {
    func detachCompletionView()
}

final class VanishingCompletionInteractor: PresentableInteractor<VanishingCompletionPresentable>,
                                           VanishingCompletionInteractable,
                                           VanishingCompletionPresentableListener {

    weak var router: VanishingCompletionRouting?
    weak var listener: VanishingCompletionListener?

    override init(presenter: VanishingCompletionPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func disappearAtExpiration() {
        listener?.detachCompletionView()
    }
}
