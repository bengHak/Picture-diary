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
}
