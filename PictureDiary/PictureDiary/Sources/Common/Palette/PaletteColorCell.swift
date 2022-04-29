//
//  PaletteColorCell.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/13.
//

import UIKit
import SnapKit
import Then

class PaletteColorCell: UICollectionViewCell {
    // MARK: - UI Properties
    private let colorRect = UIView().then {
        $0.layer.cornerRadius = 20
    }
    
    // MARK: - Properties
    static let identifier = "PaletteColorCell"
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        colorRect.layer.borderWidth = 0
        colorRect.snp.remakeConstraints {
            $0.width.height.equalTo(48)
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    private func setUI() {
        contentView.addSubview(colorRect)
        
        colorRect.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.center.equalToSuperview()
        }
    }
    
    func setColor(_ color: UIColor, isChosen: Bool) {
        colorRect.backgroundColor = color
        if color == UIColor.paletteColor(.white) {
            colorRect.layer.borderColor = UIColor.appColor(AppColorType.grayBorder).cgColor
            colorRect.layer.borderWidth = 1
        }
        
        if isChosen {
            colorRect.snp.remakeConstraints {
                $0.width.height.equalTo(56)
                $0.center.equalToSuperview()
            }
        }
    }
}
