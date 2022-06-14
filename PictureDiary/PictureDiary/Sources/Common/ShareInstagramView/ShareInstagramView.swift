//
//  ShareInstagramView.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/14.
//

import UIKit
import SnapKit
import Then

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
    }
    
    /// 그림 프레임
    private let ivPictureFrame = UIImageView(image: UIImage(named: "img_picture_frame")).then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
    }
    
    /// 그림
    private let ivPicture = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    /// 밑줄 스택
    private let underlineStack = UIStackView().then {
        $0.axis = .vertical
    }
    
    /// 일기 텍스트
    private let diaryTextView = UITextView().then {
        $0.font = .defaultFont(size: 4)
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.isEditable = false
        $0.isScrollEnabled = false
    }
    
    /// White gradient view
    private let gradientView = UIView().then { view in
        view.backgroundColor = .clear
//
//        let layer0 = CAGradientLayer()
//        layer0.colors = [
//          UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1).cgColor,
//          UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 0).cgColor
//        ]
//
//        layer0.locations = [0.06, 1]
//        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
//        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
//        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: -1, c: 1, d: 0, tx: -0.19, ty: 1))
//        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
//        layer0.position = view.center
//        view.layer.addSublayer(layer0)
    }
    
    /// 로고 뷰
    private let logoView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    /// 로고 라벨
    private let lblLogo = UILabel().then {
        $0.text = "logo"
        $0.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    }
    
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
    private func addUnderLine() {
        let underline = UIImageView(image: UIImage(named: "img_underline")).then {
            $0.contentMode = .scaleAspectFill
        }
        underlineStack.addArrangedSubview(underline)
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setLineHeight() {
        let fontLineHeight = self.diaryTextView.font?.lineHeight ?? 14
        underlineStack.spacing = fontLineHeight + 21
        diaryTextLineHeight = fontLineHeight
    }
    
    private func setData() {
        guard let imageData = diary.drawing,
              let text = diary.content,
              let date = diary.date else  {
            print("invalid diary")
            return
        }
        diaryTextView.setAttributedText(text, lineSpacing: diaryTextLineHeight ?? 10)
        ivPicture.image = UIImage(data: imageData)
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
        setLineHeight()
        
        for _ in 0..<5 { addUnderLine() }
        
        [lblWeather, ivWeather].forEach {
            weatherStack.addArrangedSubview($0)
        }
        
        [ivPictureFrame, ivPicture, underlineStack, diaryTextView, gradientView].forEach {
            diaryView.addSubview($0)
        }
        
        logoView.addSubview(lblLogo)
        
        addSubview(weatherStack)
        addSubview(diaryView)
        addSubview(logoView)
    }
    
    private func configureSubviews() {
        ivPictureFrame.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            let ratio = ivPictureFrame.image?.getImageRatio()
            let h = Float(pictureWidth) * Float(ratio!)
            $0.width.equalTo(pictureWidth)
            $0.height.equalTo(h)
        }
        
        ivPicture.snp.makeConstraints {
            $0.edges.equalTo(ivPictureFrame).inset(10)
        }
        
        underlineStack.snp.makeConstraints {
            let offset = (diaryTextLineHeight ?? 14) + 21
            $0.top.equalTo(ivPictureFrame.snp.bottom).offset(offset)
            $0.leading.trailing.equalTo(ivPictureFrame)
        }
        
        diaryTextView.snp.makeConstraints {
            $0.top.equalTo(ivPictureFrame.snp.bottom)
            $0.leading.trailing.equalTo(ivPictureFrame)
            $0.bottom.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
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
        
        lblLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        logoView.snp.makeConstraints {
            $0.trailing.equalTo(diaryView)
            $0.top.equalTo(diaryView.snp.bottom).offset(10)
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
    }
}
