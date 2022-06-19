//
//  SNSLoginViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import RxGesture
import GoogleSignIn

protocol SNSLoginPresentableListener: AnyObject {
    func login(provider: ProviderType)
}

final class SNSLoginViewController: UIViewController, SNSLoginPresentable, SNSLoginViewControllable {

    weak var listener: SNSLoginPresentableListener?
    
    // MARK: - UI properties
    /// 로고
    private let ivLogo = UIImageView(image: UIImage(named: "temp_logo")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    /// 로그인 버튼 스택
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    /// 카카오 로그인 버트
    private let btnKakao = SNSLoginButton(snsType: .kakao)
    
    /// 애플 로그인 버튼
    private let btnApple = SNSLoginButton(snsType: .apple)
    
    /// 구글 로그인 버튼
    private let btnGoogle = SNSLoginButton(snsType: .google)
    
    // MARK: - Properties
    let bag = DisposeBag()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        configureView()
        configureSubviews()
        bind()
    }
}

// MARK: - BaseViewController
extension SNSLoginViewController: BaseViewController {
    func configureView() {
        [btnKakao, btnApple, btnGoogle].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackView)
        view.addSubview(ivLogo)
    }
    
    func configureSubviews() {
        ivLogo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(200)
            $0.width.equalTo(140)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(64)
        }
        
        [btnKakao, btnApple, btnGoogle].forEach { btn in
            btn.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(56)
            }
        }
    }
    
}

extension SNSLoginViewController {
    func bind() {
        bindButtons()
    }
    
    func bindButtons() {
        Observable.merge(
            btnKakao.rx.tapGesture().when(.recognized).map { _ in return ProviderType.kakao},
            btnApple.rx.tapGesture().when(.recognized).map { _ in return ProviderType.apple},
            btnGoogle.rx.tapGesture().when(.recognized).map { _ in return ProviderType.google}
        )
        .bind(onNext: { [weak self] provider in
            guard let self = self else { return }
            self.listener?.login(provider: provider)
        })
        .disposed(by: bag)
    }
}
