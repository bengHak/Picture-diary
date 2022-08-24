//
//  SNSLoginButton.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SNSLoginButton: UIView {

    // MARK: - UI properties

    /// 버튼 UIView
    private let uiview = UIView().then {
        $0.layer.cornerRadius = 6
    }

    /// 스택뷰
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
    }

    /// SNS 로고
    private let ivLogo = UIImageView()

    /// 라벨
    public let lbl = UILabel().then {
        $0.font = .getPretendardFont(type: .bold, size: 14)
        $0.baselineAdjustment = .alignCenters
    }

    // MARK: - Properties
    var snsType: ProviderType

    init(snsType: ProviderType) {
        self.snsType = snsType
        super.init(frame: .zero)

        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func configureView() {
        stackView.addArrangedSubview(ivLogo)
        stackView.addArrangedSubview(lbl)
        uiview.addSubview(stackView)
        addSubview(uiview)

        uiview.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        configureContent()
    }

    private func configureContent() {
        switch snsType {
        case .kakao:
            buildKakaoButton()
            return
        case .apple:
            buildAppleButton()
            return
        case .google:
            buildGoogleButton()
            return
        }
    }

    private func buildKakaoButton() {
        stackView.spacing = 0
        uiview.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0.0, alpha: 1.0)
        lbl.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        lbl.text = "카카오 계정으로 로그인"
        ivLogo.image = UIImage(named: "logo_kakao")
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
    }

    private func buildAppleButton() {
        stackView.spacing = 10
        uiview.backgroundColor = .black
        lbl.textColor = .white
        lbl.text = "Apple 계정으로 로그인"
        ivLogo.image = UIImage(named: "logo_apple")
        ivLogo.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(15)
        }
    }

    private func buildGoogleButton() {
        stackView.spacing = 9
        uiview.layer.borderColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0).cgColor
        uiview.layer.borderWidth = 1
        lbl.setTextWithLineHeight(text: "Google 계정으로 로그인", fontSize: 14, fontWeight: .bold, lineHeight: 32)
        ivLogo.image = UIImage(named: "logo_google")
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
    }
}
