//
//  SignUpCompletedViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then

protocol SignUpCompletedPresentableListener: AnyObject {
    func successToLogin()
}

final class SignUpCompletedViewController: UIViewController,
                                           SignUpCompletedPresentable,
                                           SignUpCompletedViewControllable {

    weak var listener: SignUpCompletedPresentableListener?
    
    // MARK: - UI Properties
    /// 스택
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
    }
    
    /// 체크 이미지
    private let ivComplete = UIImageView().then {
        $0.image = UIImage(named: "ic_complete")
        $0.contentMode = .scaleAspectFit
    }
    
    private let lbl = UILabel().then {
        $0.text = "회원가입이 완료되었어요!"
    }
    
    // MARK: - Properties
    private var timer: Timer?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureView()
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeTimer()
    }
    
    // MARK: - Helpers
    private func initializeTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(endTimer),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc
    private func endTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
        listener?.successToLogin()
    }
}

// MARK: BaseViewController
extension SignUpCompletedViewController: BaseViewController {
    func configureView() {
        stackView.addArrangedSubview(ivComplete)
        stackView.addArrangedSubview(lbl)
        view.addSubview(stackView)
    }
    
    func configureSubviews() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
