//
//  DiaryDetailViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/05/11.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit

protocol DiaryDetailPresentableListener: AnyObject {
    func detachDiaryDetail()
    func tapShareButton(_ imageData: Data, _ completionHandler: @escaping (Bool) -> Void)
}

final class DiaryDetailViewController: UIViewController, DiaryDetailPresentable, DiaryDetailViewControllable {

    weak var listener: DiaryDetailPresentableListener?
    
    // MARK: - UI Properties
    private let appBarTop = AppBarTopView(appBarTopType: .share)
    
    /// 스크롤 뷰
    private let scrollView = UIScrollView()
    
    /// 컨텐츠 스택 뷰
    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    /// 날짜, 날시 스택
    private let dateWeatherStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    /// 날짜 라벨
    private lazy var lblDate = UILabel().then {
        if let dateText = self.diary.date?.formattedString() {
            $0.text = dateText
        }
        $0.font = .DefaultFont.body2.font()
    }
    
    /// 날씨 스택
    private let stackWeather = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    /// 맑음 이미지
    private let ivSunny = UIImageView(image: UIImage(named: "ic_weather_sunny"))
    
    /// 흐림 이미지
    private let ivCloudy = UIImageView(image: UIImage(named: "ic_weather_cloudy"))
    
    /// 비 이미지
    private let ivRain = UIImageView(image: UIImage(named: "ic_weather_rain"))
    
    /// 눈 이미지
    private let ivSnow = UIImageView(image: UIImage(named: "ic_weather_snow"))
    
    /// 그림 프레임 이미지
    private let ivPictureFrame = UIImageView(image: UIImage(named: "img_picture_frame")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    /// 그림 이미지
    private lazy var ivPicture = UIImageView().then {
        if let drawingData = self.diary.drawing {
            $0.image = UIImage(data: drawingData)
        }
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    /// 텍스트 일기장
    private let textview = UITextView().then {
        $0.font = .DefaultFont.body1.font()
        $0.backgroundColor = .clear
        $0.tintColor = .clear
        $0.isEditable = false
        $0.isScrollEnabled = false
    }
    
    private let underlineStack = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var shareInstagramView = ShareInstagramView(diary: self.diary).then {
        $0.isHidden = true
    }
    
    /// 도장 뷰
    #warning("TODO: 도장뷰")
    
    // MARK: - Properties
    private let bag = DisposeBag()
    
    /// 도장 좌표 목록
    private let stampCoordinateList: [String:Int] = [:]
    
    /// Diary data
    private let diary: PictureDiary
    
    private var diaryTextLineHeight: CGFloat?
    
    private var pictureWidth: CGFloat {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            return view.bounds.width - 40
        }
        return 340
    }
    
    // MARK: - Lifecycles
    init(diary: PictureDiary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureView()
        configureSubviews()
        
        handleWeather()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUnderLineView()
    }
    
    // MARK: - Helpers
    private func handleWeather() {
        switch WeatherType.init(rawValue: diary.weather) ?? .sunny {
        case .sunny:
            ivSunny.image = UIImage(named: "ic_weather_sunny_selected")
        case .cloudy:
            ivCloudy.image = UIImage(named: "ic_weather_cloudy_selected")
        case .rain:
            ivRain.image = UIImage(named: "ic_weather_rain_selected")
        case .snow:
            ivSnow.image = UIImage(named: "ic_weather_snow_selected")
        }
    }
    
    private func addUnderLine() {
        let underline = UIImageView(image: UIImage(named: "img_underline")).then {
            $0.contentMode = .scaleAspectFill
        }
        underlineStack.addArrangedSubview(underline)
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func setLineHeight() {
        let fontLineHeight = (self.textview.font?.lineHeight ?? 20) + 10
        underlineStack.spacing = fontLineHeight + 2.1
        diaryTextLineHeight = fontLineHeight
    }
    
    private func setUnderLineView() {
        let lineCount = textview.numberOfLine()
        if lineCount > 20 {
            for _ in 0..<lineCount-20 { addUnderLine() }
        }
    }
}

// MARK: - BaseViewController
extension DiaryDetailViewController: BaseViewController {
    func configureView() {
        setLineHeight()
        [ivSunny, ivCloudy, ivRain, ivSnow].forEach { stackWeather.addArrangedSubview($0) }
        
        dateWeatherStack.addArrangedSubview(lblDate)
        dateWeatherStack.addArrangedSubview(stackWeather)
        
        ivPictureFrame.addSubview(ivPicture)
        [dateWeatherStack, ivPictureFrame, textview].forEach {
            stackView.addArrangedSubview($0)
        }

        scrollView.addSubview(underlineStack)
        scrollView.addSubview(stackView)
        [appBarTop, scrollView].forEach {
            view.addSubview($0)
        }
        
        view.addSubview(shareInstagramView)
    }
    
    func configureSubviews() {
        shareInstagramView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(700)
            $0.width.equalTo(400)
        }
        
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        lblDate.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        dateWeatherStack.snp.makeConstraints {
            $0.width.equalTo(pictureWidth)
        }
        
        ivPictureFrame.snp.makeConstraints {
            let ratio = ivPictureFrame.image?.getImageRatio()
            let h = Float(pictureWidth) * Float(ratio!)
            $0.width.equalTo(pictureWidth)
            $0.height.equalTo(h)
        }
        
        ivPicture.snp.makeConstraints {
            $0.edges.equalTo(ivPictureFrame).inset(10)
        }
                
        textview.snp.makeConstraints {
            $0.width.equalTo(pictureWidth)
        }
        if let text = self.diary.content {
            let h = (self.diaryTextLineHeight ?? 26) - 18
            self.textview.setAttributedText(text, lineSpacing: h)
        }
        
        underlineStack.snp.makeConstraints {
            let h = diaryTextLineHeight ?? 26
            $0.top.equalTo(textview).offset(h)
            $0.leading.trailing.equalTo(ivPictureFrame)
        }
        for _ in 0..<20 { addUnderLine() }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
extension DiaryDetailViewController {
    func bind() {
        bindButtons()
    }
    
    func bindButtons() {
        appBarTop.btnBack.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.detachDiaryDetail()
            }).disposed(by: bag)
        
        appBarTop.btnShare.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.shareInstagramView.isHidden = false
                let renderer = UIGraphicsImageRenderer(bounds: self.shareInstagramView.bounds)
                let renderImage = renderer.image { context in
                    self.shareInstagramView.layer.render(in: context.cgContext)
                }
                guard let imageData = renderImage.pngData() else { return }
                self.shareInstagramView.isHidden = true
                self.listener?.tapShareButton(imageData) { isIgInstalled in
                    #warning("TODO: 인스타그램이 설치되지 않았을 경우")
                    if !isIgInstalled {
                        print("Instagram is not installed")
                    }
                }
            }).disposed(by: bag)
    }
}
