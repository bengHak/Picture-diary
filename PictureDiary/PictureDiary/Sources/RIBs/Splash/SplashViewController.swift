//
//  SplashViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Lottie

protocol SplashPresentableListener: AnyObject {
    func checkToken()
}

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable {

    weak var listener: SplashPresentableListener?
    // MARK: - UI properties
    private var animationView = AnimationView(name: "splash")

    // MARK: - Properties

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play { [weak self] isEnd in
            if isEnd {
                self?.listener?.checkToken()
            }
        }
    }

    // MARK: - Helpers
    func setup() {
        animationView.contentMode = .scaleAspectFit

        view.addSubview(animationView)

        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
