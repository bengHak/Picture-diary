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
        presentsWithGesture = false
        preferredDisplayMode = .oneBesideSecondary
        maximumPrimaryColumnWidth = 360
        minimumPrimaryColumnWidth = 360
        splitViewController?.maximumPrimaryColumnWidth = maximumPrimaryColumnWidth
        splitViewController?.minimumPrimaryColumnWidth = minimumPrimaryColumnWidth
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
