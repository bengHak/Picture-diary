//
//  FontSettingInteractor.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import RIBs
import RxSwift

protocol FontSettingRouting: ViewableRouting { }

protocol FontSettingPresentable: Presentable {
    var listener: FontSettingPresentableListener? { get set }
}

protocol FontSettingListener: AnyObject {
    func detachFontSetting()
    func reloadDiaryList()
}

final class FontSettingInteractor: PresentableInteractor<FontSettingPresentable>,
                                   FontSettingInteractable,
                                   FontSettingPresentableListener {

    weak var router: FontSettingRouting?
    weak var listener: FontSettingListener?

    override init(presenter: FontSettingPresentable) {
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
        listener?.detachFontSetting()
    }

    func reloadDiaryList() {
        listener?.reloadDiaryList()
    }
}
