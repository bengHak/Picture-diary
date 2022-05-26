//
//  RootViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/04.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject { }

final class RootViewController: UIViewController,
                                RootPresentable,
                                RootViewControllable,
                                LoggedOutViewControllable,
                                SplashViewControllable {
    
    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    
    func present(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
    
}
