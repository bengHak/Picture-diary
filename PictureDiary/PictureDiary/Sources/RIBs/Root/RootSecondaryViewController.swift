//
//  RootSecondaryViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/09.
//


import UIKit
import SnapKit
import Then
import RxSwift

/// RootSecondaryViewController
/// - 그림일기 보기
/// - 그림일기 그리기
/// - 설정 메뉴
class RootSecondaryViewController: UIViewController, LoggedInSecondaryViewControllable {
    
    // MARK: - UI Properties
    private let lblSecondary = UILabel().then {
        $0.text = "Secondary"
    }
    
    // MARK: - Properties
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        configureView()
        configureSubviews()
        bind()
    }
    
    // MARK: - Helper
}

// MARK: - BaseViewController
extension RootSecondaryViewController {
    func configureView() {
        view.addSubview(lblSecondary)
    }
    
    func configureSubviews() {
        lblSecondary.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Bindable
extension RootSecondaryViewController {
    func bind() {}
}
