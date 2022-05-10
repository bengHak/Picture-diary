//
//  DiaryCollectionViewCell.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/12.
//

import UIKit
import SnapKit
import Then
import PencilKit

final class DiaryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    private let uiview = UIView()
    
    /// 날짜
    private let lblDate = UILabel().then {
        $0.font = .DefaultFont.body2.font()
    }
    
    /// 날씨
    private let ivWeather = UIImageView()
    
    /// 일기 프레임
    private let ivFrame = UIImageView(image: UIImage(named: "img_frame"))
    
    /// 그림 일기 썸네일
    private let ivThumbnail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    
    // MARK: - Properties
    static let identifier = "DiaryCollectionViewCell"
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureView() {
        [lblDate, ivWeather, ivFrame, ivThumbnail].forEach {
            uiview.addSubview($0)
        }
        addSubview(uiview)
        
        lblDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview()
        }
        
        ivWeather.snp.makeConstraints {
            $0.leading.equalTo(lblDate.snp.trailing).offset(6)
            $0.width.height.equalTo(28)
        }
        
        ivFrame.snp.makeConstraints {
            $0.top.equalTo(lblDate.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(2)
        }
        
        ivThumbnail.snp.makeConstraints {
            $0.edges.equalTo(ivFrame).inset(2)
        }
        
        uiview.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().inset(18)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func setData(date: Date, weather: WeatherType, drawing: Data?) {
        lblDate.text = date.formattedString()
        
        if let drawing = drawing {
            ivThumbnail.image = UIImage(data: drawing)
        }
        
        switch weather {
        case .sunny:
            ivWeather.image = UIImage(named: "ic_weather_sunny_selected")
            break
        case .cloudy:
            ivWeather.image = UIImage(named: "ic_weather_cloudy_selected")
            break
        case .rain:
            ivWeather.image = UIImage(named: "ic_weather_rain_selected")
            break
        case .snow:
            ivWeather.image = UIImage(named: "ic_weather_snow_selected")
            break
        }
        
    }
}
