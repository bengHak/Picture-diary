//
//  DiaryCollectionViewCell.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/12.
//

import UIKit
import SnapKit
import Kingfisher
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

    func setData(
        id: Int,
        date: Date,
        weather: WeatherType,
        drawingImageURL: String?,
        drawingData: Data?
    ) {
        lblDate.text = date.formattedString()

        if let drawingData = drawingData {
            ivThumbnail.image = UIImage(data: drawingData)
        } else if let drawingImageURL = drawingImageURL {
            ivThumbnail.kf.setImage(with: URL(string: drawingImageURL)) { result in
                switch result {
                case .success(let imageResult):
                    let data = imageResult.image.pngData()
                    CoreDataHelper.shared.saveDiary(
                        id: id,
                        date: date,
                        weather: weather,
                        drawing: data,
                        content: ""
                    ) {
                        if $1 {
                            print("diary-\(id) is cached")
                        } else {
                            print("diary-\(id) is failed to cached")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

        switch weather {
        case .sunny:
            ivWeather.image = UIImage(named: "ic_weather_sunny_selected")
        case .cloudy:
            ivWeather.image = UIImage(named: "ic_weather_cloudy_selected")
        case .rain:
            ivWeather.image = UIImage(named: "ic_weather_rain_selected")
        case .snow:
            ivWeather.image = UIImage(named: "ic_weather_snow_selected")
        }

    }
}
