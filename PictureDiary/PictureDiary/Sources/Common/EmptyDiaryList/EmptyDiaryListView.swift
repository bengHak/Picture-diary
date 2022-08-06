//
//  EmptyDiaryListView.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/11.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class EmptyDiaryListView: UIView {

    // MARK: - UI Properties
    /// Icon image view
    private let ivIcon = UIImageView(image: UIImage(named: "ic_whang"))

    /// 아직 작성된 일기가 없어요
    private let lblNotYet = UILabel().then {
        $0.text = "아직 작성된 일기가 없어요"
        $0.font = .getPretendardFont(type: .regular, size: 18)
    }

    /// 그림일기 쓰러가기 버튼
    let btnCreateDiary = UIButton().then {
        $0.setTitle("그림일기 쓰러가기", for: .normal)
        $0.titleLabel?.font = .PretendardFont.button.font()
        $0.setTitleColor(UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1), for: .normal)
        $0.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        $0.layer.cornerRadius = 8
    }

    // MARK: - Properties
    let bag = DisposeBag()

    // MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    func configureView() {
        [ivIcon, lblNotYet, btnCreateDiary].forEach {
            addSubview($0)
        }

        lblNotYet.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        ivIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(lblNotYet.snp.top)
            $0.width.equalTo(136)
            $0.height.equalTo(124)
        }

        btnCreateDiary.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lblNotYet.snp.bottom).offset(24)
            $0.width.equalTo(146)
            $0.height.equalTo(40)
        }
    }
}
