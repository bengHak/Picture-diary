//
//  DiaryTextFieldInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/04.
//

import RIBs
import RxSwift
import RxRelay

protocol DiaryTextFieldRouting: ViewableRouting { }

protocol DiaryTextFieldPresentable: Presentable {
    var listener: DiaryTextFieldPresentableListener? { get set }
}

protocol DiaryTextFieldListener: AnyObject {
    func detachDiaryTextField()
}

final class DiaryTextFieldInteractor: PresentableInteractor<DiaryTextFieldPresentable>,
                                      DiaryTextFieldInteractable,
                                      DiaryTextFieldPresentableListener {

    weak var router: DiaryTextFieldRouting?
    weak var listener: DiaryTextFieldListener?
    let diaryText: BehaviorRelay<String>
    var initialDiaryText: String!
    private let bag: DisposeBag

    init(
        presenter: DiaryTextFieldPresentable,
        diaryText: BehaviorRelay<String>
    ) {
        self.diaryText = diaryText
        self.bag = DisposeBag()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        initialDiaryText = diaryText.value
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func cancelTyping() {
        diaryText.accept(initialDiaryText)
        listener?.detachDiaryTextField()
    }

    func completeTyping() {
        listener?.detachDiaryTextField()
    }
}
