//
//  RootPrimaryViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/09.
//


import UIKit
import SnapKit
import Then
import RxSwift
import RIBs

class RootPrimaryViewController: UIViewController, LoggedInPrimaryViewControllable {
    
    // MARK: - UI Properties
    
    // MARK: - Properties
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        configureView()
        configureSubviews()
        bind()
    }
    
    // MARK: - Helper
}

// MARK: - BaseViewController
extension RootPrimaryViewController {
    func configureView() {
    }
    
    func configureSubviews() {
    }
}

// MARK: - Bindable
extension RootPrimaryViewController {
    func bind() {}
}
