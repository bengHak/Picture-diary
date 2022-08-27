//
//  AuthRepository.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/14.
//

import Foundation
import RxSwift
import Moya

protocol AuthRepositoryProtocol {
    func authorize(with provider: ProviderType) -> Observable<ModelTokenResponse>
    func signin(token: String, provider: ProviderType) -> Observable<ModelAuthResponse>
    func signup(token: String, provider: ProviderType) -> Observable<ModelAuthResponse>
    func leave() -> Observable<CommonResponse>
}

final class AuthRepository: AuthRepositoryProtocol {

    private let provider: MoyaProvider<AuthAPI>

    init() {
        provider = MoyaProvider<AuthAPI>()
    }

    func authorize(with provider: ProviderType) -> Observable<ModelTokenResponse> {
        let oAuthService: OAuthProtocol
        switch provider {
        case .kakao:
            oAuthService = KakaoAuth()
        case .apple:
            oAuthService = AppleAuth()
        case .google:
            oAuthService = GoogleAuth()
        }
        return oAuthService.authorize()
    }

    func signin(token: String, provider: ProviderType) -> Observable<ModelAuthResponse> {
        return self.provider.rx.request(.signin(token: token, provider: provider))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode(ModelAuthResponse.self, from: $0) }
            .asObservable()
            .catch { error in
                print(error)
                return Observable.error(AuthError.serverSignInError)
            }
    }

    func signup(token: String, provider: ProviderType) -> Observable<ModelAuthResponse> {
        return self.provider.rx.request(.signup(token: token, provider: provider))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode(ModelAuthResponse.self, from: $0) }
            .asObservable()
            .catch { error in
                print("서버 회원가입 요청 실패")
                print(error)
                return Observable.error(AuthError.serverSignUpError)
            }
    }

    func leave() -> Observable<CommonResponse> {
        return self.provider.rx.request(.leave)
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode(CommonResponse.self, from: $0) }
            .asObservable()
            .catch { error in
                print(error)
                return Observable.error(AuthError.serverLeaveError)
            }
    }
}
