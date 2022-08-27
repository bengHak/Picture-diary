//
//  SettingsCollectionViewCell.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/25.
//

import Foundation
import UIKit
import SnapKit

class SettingsCollectionViewCell: UICollectionViewCell {
    // MARK: - UI properties
    private let label = UILabel().then {
        $0.font = .PretendardFont.subtitle2.font()
        $0.textColor = .appColor(.grayscale800)
    }

    private let arrow = UIImageView(image: UIImage(named: "ic_right_arrow"))

    private let versionLabel = UILabel().then {
        $0.font = .PretendardFont.body.font()
        $0.textColor = .appColor(.grayscale700)
        $0.textAlignment = .right
    }

    // MARK: - Properties
    static let identifier = "SettingsCollectionViewCell"

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    func configureView() {
        addSubview(label)
        addSubview(arrow)
        addSubview(versionLabel)

        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        arrow.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-29)
            $0.centerY.equalToSuperview()
        }

        versionLabel.snp.makeConstraints {
            $0.width.equalTo(158)
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

    func setData(_ setting: SettingType) {
        label.text = setting.name
        if !setting.hasViewController {
            arrow.isHidden = true
            versionLabel.text = currentAppVersion()
        } else {
            versionLabel.isHidden = true
        }
    }

    func currentAppVersion() -> String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let currentVersion: String = info["CFBundleShortVersionString"] as? String {
            return currentVersion
        }
        return "nil"
    }
}
