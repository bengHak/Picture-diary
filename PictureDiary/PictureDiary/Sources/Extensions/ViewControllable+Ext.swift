//
//  ViewControllable+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import UIKit

extension ViewControllable {
    func getFullScreenModalVC() -> UIViewController {
        self.uiviewController.modalTransitionStyle = .crossDissolve
        self.uiviewController.modalPresentationStyle = .overFullScreen
        return self.uiviewController
    }

    func pushViewController(_ vc: UIViewController, animated: Bool) {
        self.uiviewController.navigationController?.pushViewController(vc, animated: animated)
    }

    func popViewController(animated: Bool) {
        self.uiviewController.navigationController?.popViewController(animated: animated)
    }
}
