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

class RootSecondaryViewController: UIViewController, LoggedInSecondaryViewControllable {
    
    // MARK: - UI Properties
    
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
    }
    
    func configureSubviews() {
    }
}

// MARK: - Bindable
extension RootSecondaryViewController {
    func bind() {}
}
