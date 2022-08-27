//
//  NoticeInteractor.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs
import RxSwift

protocol NoticeRouting: ViewableRouting { }

protocol NoticePresentable: Presentable {
    var listener: NoticePresentableListener? { get set }
}

protocol NoticeListener: AnyObject {
    func detachNotice()
}

final class NoticeInteractor: PresentableInteractor<NoticePresentable>, NoticeInteractable, NoticePresentableListener {

    weak var router: NoticeRouting?
    weak var listener: NoticeListener?

    override init(presenter: NoticePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func detach() {
        listener?.detachNotice()
    }
}
