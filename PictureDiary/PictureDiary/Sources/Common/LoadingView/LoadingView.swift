//
//  LoadingView.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/04.
//

import UIKit
import SnapKit
import Then

class LoadingView: UIView {
    // MARK: - UI Properties
    private let indicator = UIActivityIndicatorView().then {
        $0.style = .large
    }

    // MARK: - Properties

    // MARK: - Lifecycles
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        indicator.stopAnimating()
    }

    // MARK: - Helpers
    private func setUI() {
        addSubview(indicator)
        indicator.snp.makeConstraints { $0.center.equalToSuperview() }
        indicator.startAnimating()
    }
}
