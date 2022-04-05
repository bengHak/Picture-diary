//
//  DiaryTextFieldViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/04.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit

protocol DiaryTextFieldPresentableListener: AnyObject {
    func cancelTyping()
    func completeTyping()
    var diaryText: BehaviorRelay<String> { get }
}

final class DiaryTextFieldViewController: UIViewController, DiaryTextFieldPresentable, DiaryTextFieldViewControllable {

    weak var listener: DiaryTextFieldPresentableListener?
    
    // MARK: - UI Properties
    /// AppBarTop
    private let appBarTop = AppBarTopView(appBarTopType: .completion)
    
    /// 텍스트 뷰
    private let textview = UITextView().then {
        $0.font = .DefaultFont.body1.font()
    }
    
    /// 텍스트 뷰 placeholder
    private let lblPlaceholder = UILabel().then {
        $0.text = "여기에 일기를 입력해주세요."
        $0.font = .DefaultFont.body1.font()
        $0.textColor = .secondaryLabel
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Properties
    let bag = DisposeBag()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureView()
        configureSubviews()
        bind()
    }
    
    // MARK: - Helpers

}

// MARK: BaseViewController
extension DiaryTextFieldViewController: BaseViewController {
    func configureView() {
        view.addSubview(appBarTop)
        view.addSubview(textview)
        view.addSubview(lblPlaceholder)
    }

    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        textview.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        textview.text = listener?.diaryText.value ?? ""
        
        lblPlaceholder.snp.makeConstraints {
            $0.top.leading.equalTo(textview).offset(4)
        }
    }
    
    
}

// MARK: Bindable
extension DiaryTextFieldViewController {
    func bind() {
        bindButtons()
        bindTextView()
    }
    
    func bindButtons() {
        appBarTop.btnBack.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.cancelTyping()
            }).disposed(by: bag)
        
        appBarTop.btnCompleted.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.completeTyping()
            }).disposed(by: bag)
    }
    
    func bindTextView() {
        textview.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.lblPlaceholder.isHidden = !text.isEmpty
                self.textview.setAttributedText(text)
                self.listener?.diaryText.accept(text)
            }).disposed(by: bag)
    }
}
