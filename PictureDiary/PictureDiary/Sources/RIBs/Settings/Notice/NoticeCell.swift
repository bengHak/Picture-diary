//
//  NoticeCell.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/26.
//

import Foundation
import UIKit
import SnapKit

class NoticeCell: UICollectionViewCell {
    // MARK: - UI properties
    private let label = UILabel().then {
        $0.textColor = .appColor(.grayscale800)
    }

    private let separator = UIView().then {
        $0.backgroundColor = .appColor(.grayscale200)
    }

    // MARK: - Properties
    static let identifier = "NoticeCell"

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    func configuerView() {
        addSubview(label)
        addSubview(separator)

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }

    func setData(_ notice: String) {
        label.text = notice
    }
}
