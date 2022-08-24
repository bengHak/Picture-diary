//
//  StampDrawerCell.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import Foundation
import UIKit
import SnapKit
import Then

final class StampDrawerCell: UICollectionViewCell {
    // MARK: - UI properties
    let stampImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Properties
    static let identifier = "StampDrawerCell"
    var stamp: StampType!

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func setUI() {
        addSubview(stampImageView)

        stampImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(74)
        }
    }

    func setStamp(with stampType: StampType) {
        self.stamp = stampType
        stampImageView.image = UIImage(named: stampType.imageName)
    }
}
