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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SignUpCompletedViewController: UIViewController,
                                           SignUpCompletedPresentable,
                                           SignUpCompletedViewControllable {

    weak var listener: SignUpCompletedPresentableListener?
    
    // MARK: - UI Properties
    private let lbl = UILabel().then {
        $0.text = "회원가입이 완료되었어요!"
    }
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureView()
        configureSubviews()
    }
    
    // MARK: - Helpers
}

// MARK: BaseViewController
extension SignUpCompletedViewController: BaseViewController {
    func configureView() {
        view.addSubview(lbl)
    }
    
    func configureSubviews() {
        lbl.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
