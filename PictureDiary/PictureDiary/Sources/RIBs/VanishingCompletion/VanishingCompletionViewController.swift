//
//  VanishingCompletionViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then

protocol VanishingCompletionPresentableListener: AnyObject {
    func disappearAtExpiration()
}

final class VanishingCompletionViewController: UIViewController,
                                               VanishingCompletionPresentable,
                                               VanishingCompletionViewControllable {
    
    weak var listener: VanishingCompletionPresentableListener?
    
    // MARK: - UI Properties
    /// 스택
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
    }
    
    /// 체크 이미지
    private let ivComplete = UIImageView().then {
        $0.image = UIImage(named: "ic_complete")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var lbl = UILabel().then {
        $0.text = self.labelText
    }
    
    // MARK: - Properties
    private let labelText: String
    private var timer: Timer?
    
    // MARK: - Lifecycles
    init(_ labelText: String) {
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeTimer()
    }
    
    // MARK: - Helpers
    private func initializeTimer() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 1.5,
            target: self,
            selector: #selector(endTimer),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc
    private func endTimer() {
        timer?.invalidate()
        timer = nil
        listener?.disappearAtExpiration()
    }
}

// MARK: BaseViewController
extension VanishingCompletionViewController: BaseViewController {
    func configureView() {
        stackView.addArrangedSubview(ivComplete)
        stackView.addArrangedSubview(lbl)
        view.addSubview(stackView)
    }
    
    func configureSubviews() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
