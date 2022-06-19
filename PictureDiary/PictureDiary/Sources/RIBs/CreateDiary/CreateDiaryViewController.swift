//
//  CreateDiaryViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxSwift
import RxCocoa
import RxGesture
import UIKit
import SnapKit
import Then
import PencilKit

protocol CreateDiaryPresentableListener: AnyObject {
    func tapDrawingCompleteButton()
    func tapCancleButton()
    func routeToDiaryTextField()
    func routeToDiaryDrawing()
    var diaryText: BehaviorRelay<String> { get }
}

final class CreateDiaryViewController: UIViewController, CreateDiaryPresentable, CreateDiaryViewControllable {
    
    weak var listener: CreateDiaryPresentableListener?
    
    // MARK: - UI Properties
    /// Scroll view
    private let scrollView = UIScrollView()
    
    /// Scroll content view
    private let scrollContentView = UIView()
    
    /// App bar top
    private let appBarTop = AppBarTopView(appBarTopType: .completion)
    
    /// 날짜 라벨
    private let lblDate = UILabel().then {
        $0.text = Date().formattedString()
        $0.font = .DefaultFont.body2.font()
    }
    
    /// 날씨 스택
    private let stackWeather = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    /// 맑음 이미지
    private let ivSunny = UIImageView(image: UIImage(named: "ic_weather_sunny_selected"))
    
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
    private let ivPicture = UIImageView().then {
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
    
    /// 텍스트 뷰 placeholder
    private let lblPlaceholder = UILabel().then {
        $0.text = "여기에 일기를 입력해주세요."
        $0.font = .DefaultFont.body1.font()
        $0.textColor = .secondaryLabel
        $0.isUserInteractionEnabled = false
    }
    
    private let underlineStack = UIStackView().then {
        $0.axis = .vertical
    }
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var currentNumberOfLines = 0
    private var diaryTextLineHeight: CGFloat?
    private var currentWeather = WeatherType.sunny
    private var currentDate = Date()
    private var drawingData: BehaviorRelay<Data?>
    private var drawingImage: BehaviorRelay<UIImage?>
    
    // MARK: - Lifecycles
    init(
        drawingImage: BehaviorRelay<UIImage?>,
        drawingData: BehaviorRelay<Data?>
    ) {
        self.drawingImage = drawingImage
        self.drawingData = drawingData
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
        bind()
    }
    
    
    // MARK: - Helpers
    #warning("날씨 관련 기능 extension으로 추출하기")
    private func handleWeather(weather: WeatherType) {
        switch currentWeather {
        case .sunny:
            ivSunny.image = UIImage(named: "ic_weather_sunny")
        case .cloudy:
            ivCloudy.image = UIImage(named: "ic_weather_cloudy")
        case .rain:
            ivRain.image = UIImage(named: "ic_weather_rain")
        case .snow:
            ivSnow.image = UIImage(named: "ic_weather_snow")
        }
        
        currentWeather = weather
        switch weather {
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
    
    func configureScrollView() {
        let h = self.textview.frame.origin.y + self.textview.frame.height - self.appBarTop.frame.origin.y + self.appBarTop.frame.height
        let w = self.scrollContentView.frame.width
        let contentSize = CGSize(width: w, height: h)
        self.scrollContentView.frame.size = contentSize
        self.scrollView.contentSize = contentSize
    }
}

// MARK: BaseViewController
extension CreateDiaryViewController: BaseViewController {
    func configureView() {
        setLineHeight()
        for _ in 0..<5 { addUnderLine() }
        [ivSunny, ivCloudy, ivRain, ivSnow].forEach { stackWeather.addArrangedSubview($0) }
        [lblDate, stackWeather, ivPictureFrame, ivPicture, textview, lblPlaceholder].forEach { scrollContentView.addSubview($0) }
        scrollView.addSubview(scrollContentView)
        view.addSubview(appBarTop)
        view.addSubview(underlineStack)
        view.addSubview(scrollView)
    }
    
    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        lblDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        
        stackWeather.snp.makeConstraints {
            $0.centerY.equalTo(lblDate)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        ivPictureFrame.snp.makeConstraints {
            let w: CGFloat
            let ratio = ivPictureFrame.image?.getImageRatio()
            if UITraitCollection.current.horizontalSizeClass == .compact {
                w = view.bounds.width - 40
            } else {
                w = 340
            }
            let h = Float(w) * Float(ratio!)
            $0.width.equalTo(w)
            $0.height.equalTo(h)
            $0.top.equalTo(lblDate.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        ivPicture.snp.makeConstraints {
            $0.edges.equalTo(ivPictureFrame).inset(10)
        }
        
        underlineStack.snp.makeConstraints {
            let h = (diaryTextLineHeight ?? 26) + 8
            $0.top.equalTo(ivPictureFrame.snp.bottom).offset(h)
            $0.leading.trailing.equalTo(ivPictureFrame)
        }
        for _ in 0..<20 { addUnderLine() }
        
        textview.snp.remakeConstraints {
            $0.top.equalTo(ivPictureFrame.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(ivPictureFrame)
            $0.height.greaterThanOrEqualTo(150)
        }
        
        lblPlaceholder.snp.makeConstraints {
            $0.top.leading.equalTo(textview).offset(10)
        }
        lblPlaceholder.isHidden = !(textview.text?.isEmpty ?? true)

        scrollContentView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bindable
extension CreateDiaryViewController {
    private func bind() {
        bindWeather()
        bindPicture()
        bindTextView()
        bindButtons()
        bindText()
        bindDrawingData()
    }
    
    private func bindWeather() {
        ivSunny.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleWeather(weather: .sunny)
            }).disposed(by: bag)
        
        ivRain.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleWeather(weather: .rain)
            }).disposed(by: bag)
        
        ivCloudy.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleWeather(weather: .cloudy)
            }).disposed(by: bag)
        
        ivSnow.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleWeather(weather: .snow)
            }).disposed(by: bag)
    }
    
    private func bindPicture() {
        ivPicture.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.routeToDiaryDrawing()
            }).disposed(by: bag)
    }
    
    private func bindTextView() {
        textview.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.routeToDiaryTextField()
            }).disposed(by: bag)
    }
    
    private func bindButtons() {
        appBarTop.btnBack.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
#warning("저장하지 않고 뒤로가시겠습니까? 알려줘야되지 않을까")
                self.listener?.tapCancleButton()
            }).disposed(by: bag)
        
        appBarTop.btnCompleted.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.textview.text.isEmpty {
                    #warning("텍스트 없는 일기는 저장하지 않게하는 로직 추가하기")
                    print("🔴 일기가 입력되지 않았습니다.")
                    return
                }
                
                let dataHelper = CoreDataHelper.shared
                dataHelper.saveDiary(date: self.currentDate,
                                     weather: self.currentWeather,
                                     drawing: self.drawingImage.value!.pngData(),
                                     content: self.textview.text) { success in
                    print(success)
                }
                self.listener?.tapDrawingCompleteButton()
            }).disposed(by: bag)
    }
    
    private func bindText() {
        listener?.diaryText
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let h = (self.diaryTextLineHeight ?? 26) - 18
                self.textview.setAttributedText(text, lineSpacing: h)
                self.lblPlaceholder.isHidden = !text.isEmpty
            }).disposed(by: bag)
    }
    
    private func bindDrawingData() {
        drawingImage
            .subscribe(onNext: { [weak self] image in
                guard let self = self,
                      let image = image else {
                    return
                }
                self.ivPicture.image = image
            }).disposed(by: bag)
    }
}
