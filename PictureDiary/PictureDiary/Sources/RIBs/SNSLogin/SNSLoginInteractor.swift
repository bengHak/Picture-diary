//
//  SNSLoginInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import RxRelay
import SwiftKeychainWrapper

protocol SNSLoginRouting: ViewableRouting { }

protocol SNSLoginPresentable: Presentable {
    var listener: SNSLoginPresentableListener? { get set }
}

protocol SNSLoginListener: AnyObject {
    func didLogin()
    func didSignUp()
}

final class SNSLoginInteractor: PresentableInteractor<SNSLoginPresentable>,
                                SNSLoginInteractable,
                                SNSLoginPresentableListener {
    weak var router: SNSLoginRouting?
    weak var listener: SNSLoginListener?
    private let authRepository: AuthRepositoryProtocol
    private let isSignInSuccess: PublishSubject<Bool>
    private let isSignUpSuccess: PublishSubject<Bool>
    private let providerToken: BehaviorRelay<String>
    private let bag: DisposeBag
    
    init(
        presenter: SNSLoginPresentable,
        authRepository: AuthRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.isSignInSuccess = PublishSubject<Bool>()
        self.isSignUpSuccess = PublishSubject<Bool>()
        self.providerToken = BehaviorRelay<String>(value: "")
        self.bag = DisposeBag()
        super.init(presenter: presenter)
        presenter.listener = self
        
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        bindSuccessValue()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func loginCompleted() {
        listener?.didLogin()
    }
    
    func signUpCompleted() {
        listener?.didSignUp()
    }
    
    func login(provider: ProviderType) {
        signInWithSsgSsgServer(provider)
    }
    
    private func signInWithSsgSsgServer(_ provider: ProviderType) {
        authRepository.authorize(with: provider)
            .filter { $0.success }
            .flatMapLatest { [weak self] (response) -> Observable<ModelAuthResponse> in
                guard let self = self,
                      let token = response.token else {
                    throw AuthError.invalidProviderToken
                }
                self.providerToken.accept(token)
                return self.authRepository.signin(token: token, provider: provider)
            }
            .catch { [weak self] error in
                self?.isSignInSuccess.onNext(false)
                self?.signUpWithSsgSsgServer(provider)
                return Observable.error(error)
            }
            .subscribe(onNext: { [weak self] authResponse in
                guard let self = self,
                      let accessToken = authResponse.accessToken else {
                    self?.isSignInSuccess.onNext(false)
                    return
                }
                KeychainWrapper.setValue(accessToken, forKey: .accessToken)
                self.isSignInSuccess.onNext(true)
            })
            .disposed(by: bag)
    }
    
    private func signUpWithSsgSsgServer(_ provider: ProviderType) {
        print(#function)
        print(self.providerToken.value)
        authRepository.signup(token: self.providerToken.value, provider: provider)
            .catch { [weak self] error in
                self?.isSignUpSuccess.onNext(false)
                return Observable.error(error)
            }
            .subscribe(onNext: { [weak self] authResponse in
                guard let self = self,
                      let accessToken = authResponse.accessToken else {
                    self?.isSignUpSuccess.onNext(false)
                    return
                }
                KeychainWrapper.setValue(accessToken, forKey: .accessToken)
                self.isSignUpSuccess.onNext(true)
            })
            .disposed(by: bag)
    }
    
    private func bindSuccessValue() {
        self.isSignInSuccess
            .bind(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.loginCompleted()
                } else {
#warning("????????? ?????? ?????? ??????")
                    print("???? ????????? ??????")
                }
            })
            .disposed(by: bag)
        
        self.isSignUpSuccess
            .bind(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.signUpCompleted()
                } else {
#warning("???????????? ?????? ?????? ??????")
                    print("???? ???????????? ??????")
                }
            })
            .disposed(by: bag)
    }
}
