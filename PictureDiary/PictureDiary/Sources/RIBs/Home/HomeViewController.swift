//
//  HomeViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then

protocol HomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?
    
    // MARK: - UI Properties
    /// 홈 라벨
    private let lbl = UILabel().then {
        $0.text = "This is home"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
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
extension HomeViewController: BaseViewController {
    func configureView() {
        view.addSubview(lbl)
    }
    
    func configureSubviews() {
        lbl.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
