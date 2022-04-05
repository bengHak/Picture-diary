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
    var diaryText: BehaviorRelay<String> { get }
}

final class DiaryTextFieldInteractor: PresentableInteractor<DiaryTextFieldPresentable>, DiaryTextFieldInteractable, DiaryTextFieldPresentableListener {
    
    weak var router: DiaryTextFieldRouting?
    weak var listener: DiaryTextFieldListener?
    let diaryText: BehaviorRelay<String>
    var initialDiaryText: String!
    private let bag: DisposeBag

    override init(presenter: DiaryTextFieldPresentable) {
        self.diaryText = BehaviorRelay<String>(value: "")
        self.bag = DisposeBag()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        diaryText.accept(listener?.diaryText.value ?? "")
        initialDiaryText = diaryText.value
        bindText()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func cancelTyping() {
        listener?.diaryText.accept(initialDiaryText)
        listener?.detachDiaryTextField()
    }
    
    func completeTyping() {
        listener?.detachDiaryTextField()
    }
    
    // MARK: - Bind
    func bindText() {
        diaryText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.listener?.diaryText.accept(text)
        }).disposed(by: bag)
    }
}
