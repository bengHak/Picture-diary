//
//  FontSettingCell.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import Foundation
import UIKit
import SnapKit

class FontSettingCell: UICollectionViewCell {
    // MARK: - UI properties
    private let label = UILabel().then {
        $0.textColor = .appColor(.grayscale800)
    }

    private let checkedImage = UIImageView(image: UIImage(named: "ic_checked"))

    private let separator = UIView().then {
        $0.backgroundColor = .appColor(.grayscale200)
    }

    // MARK: - Properties
    static let identifier = "FontSettingCell"

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        checkedImage.isHidden = true
    }
    // MARK: - Helpers
    func configuerView() {
        addSubview(label)
        addSubview(checkedImage)
        addSubview(separator)

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        checkedImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        checkedImage.isHidden = true

        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }

    func setData(_ font: UIFont.DefaultFontType) {
        if UserDefaults.getDefaultFont() == font {
            checkedImage.isHidden = false
        } else {
            checkedImage.isHidden = true
        }
        label.text = font.name
        label.font = UIFont(name: font.rawValue, size: 16)
    }
}
