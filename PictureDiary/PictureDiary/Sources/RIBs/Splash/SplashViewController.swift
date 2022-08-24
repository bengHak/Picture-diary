//
//  SplashViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/06.
//

import RIBs
import RxSwift
import UIKit

protocol SplashPresentableListener: AnyObject { }

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable {

    weak var listener: SplashPresentableListener?
}
