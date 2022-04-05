//
//  AppBarTop.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import UIKit
import SnapKit
import Then

final class AppBarTopView: UIView {

    // MARK: - UI Properties
    /// 타이틀
    private lazy var lblTitle = UILabel().then {
        $0.font = .PretendardFont.h2.font()
    }
    
    /// 그림일기 그리기 버튼
    lazy var btnCreate = UIButton().then {
        $0.setImage(UIImage(named: "ic_create_diary"), for: .normal)
    }
    
    /// 사람 버튼
    lazy var btnPeople = UIButton().then {
        $0.setImage(UIImage(named: "ic_people"), for: .normal)
    }
    
    /// 설정 버튼
    lazy var btnSetting = UIButton().then {
        $0.setImage(UIImage(named: "ic_setting"), for: .normal)
    }
    
    /// 완료 버튼
    lazy var btnCompleted = UIButton().then {
        let color = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        $0.setTitleColor(color, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .PretendardFont.button.font()
    }
    
    /// 공유 버튼
    lazy var btnShare = UIButton().then {
        $0.setImage(UIImage(named: "ic_share_insta"), for: .normal)
    }
    
    /// 뒤로가기 버튼
    lazy var btnBack = UIButton().then {
        $0.setImage(UIImage(named: "ic_appbar_back"), for: .normal)
    }
    
    // MARK: - Properties
    let appBarTopType: AppBarTopType
    
    // MARK: - Lifecycles
    init(appBarTopType: AppBarTopType) {
        self.appBarTopType = appBarTopType
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureView() {
        switch appBarTopType {
        case .main:
            buildMain()
            break
        case .completion:
            buildCompletion()
            break
        case .share:
            buildShare()
            break
        case .simpleTitle:
            buildSimpleTitle()
            break
        }
    }
    
    private func buildMain() {
        [btnCreate, btnPeople, btnSetting].forEach { addSubview($0) }
        
        btnSetting.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(26)
            $0.width.height.equalTo(31)
        }
        
        btnPeople.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(btnSetting.snp.leading).offset(-14)
            $0.width.height.equalTo(32)
        }
        
        btnCreate.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(btnPeople.snp.leading).offset(-14)
            $0.width.height.equalTo(32)
        }
    }
    
    private func buildCompletion() {
        buildBackButton()
        addSubview(btnCompleted)
        btnCompleted.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func buildShare() {
        buildBackButton()
        addSubview(btnShare)
        btnShare.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    private func buildSimpleTitle() {
        buildBackButton()
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    private func buildBackButton() {
        addSubview(btnBack)
        btnBack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(28)
        }
    }
}
