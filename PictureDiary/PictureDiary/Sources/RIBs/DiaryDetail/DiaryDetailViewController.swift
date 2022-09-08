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
import Kingfisher

protocol DiaryDetailPresentableListener: AnyObject {
    func detachDiaryDetail()
    func tapShareButton(_ imageData: Data)
}

final class DiaryDetailViewController: UIViewController, DiaryDetailPresentable, DiaryDetailViewControllable {

    weak var listener: DiaryDetailPresentableListener?

    // MARK: - UI Properties
    private let appBarTop = AppBarTopView(appBarTopType: .share)

    /// 스크롤 뷰
    private let scrollView = UIScrollView()

    /// 컨텐츠 스택 뷰
    let stackView = UIStackView().then {
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
    let ivPictureFrame = UIImageView(image: UIImage(named: "img_picture_frame")).then {
        $0.contentMode = .scaleAspectFit
    }

    /// 그림 이미지
    private lazy var ivPicture = UIImageView().then {
        if let drawingData = self.diary.drawing {
            $0.image = UIImage(data: drawingData)
        } else if let url = self.diary.imageUrl {
            $0.kf.setImage(with: URL(string: url))
        }
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let underlineStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
    }

    private lazy var shareInstagramView = ShareInstagramView(diary: self.diary).then {
        $0.isHidden = true
    }

    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Properties
    private let bag = DisposeBag()

    /// 도장 좌표 목록
    private let stampCoordinateList: [String: Int] = [:]

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
        addGestureRecognizer()
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
        handleStamps()
        bind()
    }

    // MARK: - Helpers
    private func handleStamps() {
        diary.stampList.forEach {
            guard let stampString = $0.stampType,
                  let stamp = StampType.init(rawValue: stampString),
                  let proportionalX = $0.x,
                  let proportionalY = $0.y else {
                return
            }
            let stampView = UIImageView(image: UIImage(named: stamp.imageName))
            let w = ivPictureFrame.frame.width
            let h = ivPictureFrame.frame.height

            view.addSubview(stampView)
            stampView.snp.makeConstraints {
                $0.leading.equalTo(ivPictureFrame).offset(proportionalX * w)
                $0.top.equalTo(ivPictureFrame).offset(proportionalY * h)
                $0.width.height.equalTo(80)
            }
        }
    }

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

    private func addGestureRecognizer() {
        let gesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeGesture(_:))
        )
        gesture.direction = .right
        self.view.addGestureRecognizer(gesture)
    }

    @objc
    private func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        listener?.detachDiaryDetail()
    }
}

// MARK: - BaseViewController
extension DiaryDetailViewController: BaseViewController {
    func configureView() {
        [ivSunny, ivCloudy, ivRain, ivSnow].forEach { stackWeather.addArrangedSubview($0) }

        dateWeatherStack.addArrangedSubview(lblDate)
        dateWeatherStack.addArrangedSubview(stackWeather)

        ivPictureFrame.addSubview(ivPicture)
        [dateWeatherStack, ivPictureFrame, underlineStack].forEach {
            stackView.addArrangedSubview($0)
        }

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
            let h = Float(pictureWidth) * Float(ratio ?? 1.25)
            $0.width.equalTo(pictureWidth)
            $0.height.equalTo(h)
        }

        ivPicture.snp.makeConstraints {
            $0.edges.equalTo(ivPictureFrame).inset(10)
        }

        var splitted = splitString(diary.content ?? "")
        while splitted.count < 8 { splitted.append("") }
        splitted.forEach { addUnderLine($0) }

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
                self.selectionFeedbackGenerator.selectionChanged()
                self.listener?.detachDiaryDetail()
            }).disposed(by: bag)

        appBarTop.btnShare.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.selectionFeedbackGenerator.selectionChanged()
                self.shareInstagramView.isHidden = false
                #warning("그림자 렌더링 타이밍 수정 필요")
                self.shareInstagramView.setGradient()
                let renderer = UIGraphicsImageRenderer(bounds: self.shareInstagramView.bounds)
                let renderImage = renderer.image { context in
                    self.shareInstagramView.layer.render(in: context.cgContext)
                }
                guard let imageData = renderImage.pngData() else { return }
                self.shareInstagramView.isHidden = true
                self.listener?.tapShareButton(imageData)
            }).disposed(by: bag)
    }
}
