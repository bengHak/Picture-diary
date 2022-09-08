//
//  ShareInstagramView.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/14.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ShareInstagramView: UIView {

    // MARK: - UI Properties

    /// 날씨 스택
    private let weatherStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 9.5
    }

    /// 날씨 라벨
    private let lblWeather = UILabel().then {
        $0.font = .DefaultFont.body2.font()
    }

    /// 날씨 이미지
    private let ivWeather = UIImageView()

    /// 다이어리 뷰
    private let diaryView = UIView().then {
        $0.backgroundColor = .appColor(.grayscale100)
        $0.layer.cornerRadius = 12
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowRadius = 20
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }

    /// 그림 프레임
    private let ivPictureFrame = UIImageView(image: UIImage(named: "img_picture_frame")).then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
    }

    /// 그림
    private let ivPicture = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    /// 밑줄 스택
    private let underlineStack = UIStackView().then {
        $0.axis = .vertical
    }

    /// 일기 텍스트
    private let diaryTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainer.maximumNumberOfLines = 5
        $0.textContainer.lineBreakMode = .byTruncatingTail
    }

    /// White gradient view
    private let gradientView = UIView()

    /// 로고 뷰
    private let logoView = UIImageView(image: UIImage(named: "small_logo_no_bg"))

    // MARK: - Properties
    private var diaryTextLineHeight: CGFloat?
    private let diary: PictureDiary
    private var pictureWidth: CGFloat {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            return UIScreen.main.bounds.width - 100
        }
        return 230
    }

    // MARK: - Init
    init(diary: PictureDiary) {
        self.diary = diary
        super.init(frame: .zero)
        backgroundColor = .clear
        configureView()
        configureSubviews()
        setData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func splitString(_ string: String) -> [String] {
        let inputText: [String] = Array(string).map { String($0) }
        let labelWidth = pictureWidth - 20
        var resultArray: [String] = []
        var readerString = ""
        for i in 0 ..< inputText.count {
            readerString += inputText[i]
            if readerString.widthOfString(usingFont: .DefaultFont.body1.font()) >= labelWidth ||
                inputText.count - 1 == i {
                resultArray.append(readerString)
                readerString = ""
            }
        }
        return resultArray
    }

    func setGradient() {
        if let subLayers = gradientView.layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }

    private func addUnderLine(_ text: String) {
        let uiview = UIView()
        let uilabel = UILabel().then {
            $0.font = .DefaultFont.body1.font()
            $0.text = text
        }
        let underline = UIImageView(image: UIImage(named: "img_underline")).then {
            $0.contentMode = .scaleAspectFill
        }

        uiview.addSubview(uilabel)
        underlineStack.addArrangedSubview(uiview)
        underlineStack.addArrangedSubview(underline)

        uiview.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        uilabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }

    private func setData() {
        guard let imageUrl = diary.imageUrl,
              let date = diary.date else {
            print("ShareInstagramView - invalid diary")
            return
        }

        if let text = diary.content {
            diaryTextView.setAttributedText(text, lineSpacing: diaryTextLineHeight ?? 10, font: .body2)
        }

        let url = URL(string: imageUrl)
        ivPicture.kf.setImage(with: url)
        lblWeather.text = date.formattedString()

        switch WeatherType.init(rawValue: diary.weather) ?? .sunny {
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

    private func configureView() {
        [lblWeather, ivWeather].forEach {
            weatherStack.addArrangedSubview($0)
        }

        [ivPictureFrame, ivPicture, underlineStack, gradientView].forEach {
            diaryView.addSubview($0)
        }

        addSubview(weatherStack)
        addSubview(diaryView)
        addSubview(logoView)
    }

    private func configureSubviews() {
        ivPictureFrame.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            let ratio = ivPictureFrame.image?.getImageRatio()
            let h = Float(pictureWidth) * Float(ratio ?? 1.25)
            $0.width.equalTo(pictureWidth)
            $0.height.equalTo(h)
        }

        ivPicture.snp.makeConstraints {
            $0.edges.equalTo(ivPictureFrame).inset(10)
        }

        underlineStack.snp.makeConstraints {
            $0.top.equalTo(ivPictureFrame.snp.bottom)
            $0.leading.trailing.equalTo(ivPictureFrame)
        }

        var splitted = splitString(diary.content ?? "")
        while splitted.count < 5 { splitted.append("") }
        for i in 0..<5 {
            addUnderLine(splitted[i])
        }

        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(diaryView)
            $0.height.equalTo(30)
        }

        diaryView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalTo(ivPictureFrame).offset(-16)
            $0.bottom.equalTo(underlineStack).offset(16)
            $0.width.equalTo(pictureWidth + 32)
        }

        weatherStack.snp.makeConstraints {
            $0.leading.equalTo(diaryView)
            $0.bottom.equalTo(diaryView.snp.top).offset(-8)
        }

        logoView.snp.makeConstraints {
            $0.trailing.equalTo(diaryView)
            $0.top.equalTo(diaryView.snp.bottom).offset(10)
            $0.width.equalTo(43)
            $0.height.equalTo(27)
        }
    }
}
