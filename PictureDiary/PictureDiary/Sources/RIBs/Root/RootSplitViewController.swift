//
//  RootSplitViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs
import RxSwift
import UIKit

final class RootSplitViewController: UISplitViewController,
                                     RootPresentable,
                                     RootViewControllable {
    var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .green
        
        presentsWithGesture = false
        preferredDisplayMode = .oneBesideSecondary
        delegate = self
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

// MARK: - UISplitViewControllerDelegate
extension RootSplitViewController: UISplitViewControllerDelegate {
    
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
