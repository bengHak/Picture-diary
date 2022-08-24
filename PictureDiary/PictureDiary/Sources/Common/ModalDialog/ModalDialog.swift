//
//  ModalDialog.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/14.
//

import UIKit
import SnapKit
import Then

class ModalDialog: UIView {
    // MARK: - UI Properties
    /// 배경 뷰
    private let bgview = UIView().then {
        $0.backgroundColor = UIColor.appColor(.dim)
    }

    /// 모달 dialog
    private let uiviewModal = UIView().then {
        $0.backgroundColor = UIColor.appColor(.white)
        $0.layer.cornerRadius = 8
    }

    /// 메시지
    private let lblMessage = UILabel().then {
        $0.font = .PretendardFont.subtitle2.font()
    }

    /// 스택
    private let stack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
    }

    /// Divider
    private let divider = UIView().then {
        $0.backgroundColor = .appColor(.grayscale300)
    }

    /// 왼쪽 버튼
    let btnLeft = UIButton().then {
        $0.setTitleColor(.appColor(.grayscale600), for: .normal)
        $0.titleLabel?.font = .PretendardFont.button.font()
    }

    /// 오른쪽 버튼
    let btnRight = UIButton().then {
        $0.setTitleColor(.appColor(.grayscale900), for: .normal)
        $0.titleLabel?.font = .PretendardFont.button.font()
    }

    // MARK: - Properties

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func setUI() {
        stack.addArrangedSubview(btnLeft)
        stack.addArrangedSubview(divider)
        stack.addArrangedSubview(btnRight)

        uiviewModal.addSubview(lblMessage)
        uiviewModal.addSubview(stack)
        addSubview(bgview)
        addSubview(uiviewModal)

        bgview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        uiviewModal.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(143)
        }

        lblMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(32)
        }

        divider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(24)
        }

        btnLeft.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalToSuperview()
        }

        btnRight.snp.makeConstraints {
            $0.width.height.equalTo(btnLeft)
        }

        stack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lblMessage.snp.bottom).offset(32)
            $0.height.equalTo(59)
        }
    }

    func setButton(message: String, leftMessage: String, rightMessage: String) {
        lblMessage.text = message
        btnLeft.setTitle(leftMessage, for: .normal)
        btnRight.setTitle(rightMessage, for: .normal)
    }
}
