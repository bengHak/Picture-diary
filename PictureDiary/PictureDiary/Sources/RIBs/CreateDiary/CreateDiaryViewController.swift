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

protocol CreateDiaryPresentableListener: AnyObject {
    func detachCreateDiary()
    func attachDiaryTextField()
    func attachDiaryDrawing()
    var diaryText: BehaviorRelay<String> { get }
}

final class CreateDiaryViewController: UIViewController, CreateDiaryPresentable, CreateDiaryViewControllable {
    
    weak var listener: CreateDiaryPresentableListener?
    
    // MARK: - UI Properties
    /// App bar top
    private let appBarTop = AppBarTopView(appBarTopType: .completion)
    
    /// 날짜 라벨
    private let lblDate = UILabel().then {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 M월 dd일"
        $0.text = dateFormatter.string(from: date)
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
    private let ivPicture = UIImageView()
    
    /// 텍스트 일기장
    private let textview = UITextView().then {
        $0.font = .DefaultFont.body1.font()
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
        $0.tintColor = .clear
    }
    
    /// 텍스트 뷰 placeholder
    private let lblPlaceholder = UILabel().then {
        $0.text = "여기에 일기를 입력해주세요."
        $0.font = .DefaultFont.body1.font()
        $0.textColor = .secondaryLabel
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var currentNumberOfLines = 0
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        configureView()
        configureSubviews()
        bind()
    }
    
    // MARK: - Helpers
}

// MARK: BaseViewController
extension CreateDiaryViewController: BaseViewController {
    func configureView() {
        [ivSunny, ivCloudy, ivRain, ivSnow].forEach { stackWeather.addArrangedSubview($0) }
        [appBarTop, lblDate, stackWeather, ivPictureFrame, ivPicture, textview, lblPlaceholder].forEach { view.addSubview($0) }
    }
    
    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        lblDate.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(20)
        }
        
        stackWeather.snp.makeConstraints {
            $0.centerY.equalTo(lblDate)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        ivPictureFrame.snp.makeConstraints {
            $0.top.equalTo(lblDate.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            let ratio = ivPictureFrame.image?.getImageRatio()
            let w: CGFloat
            // 아이폰
            if view.bounds.width < 500 {
                w = view.bounds.width - 40
            } else {
                // 아이패드
                if view.bounds.width < view.bounds.height {
                    // 세로
                    w = view.bounds.width - 40 - 360
                } else {
                    // 가로
                    w = 340
                }
            }
            let h = Float(w) * Float(ratio!)
            $0.height.equalTo(h)
        }
        
        ivPicture.snp.makeConstraints {
            $0.edges.equalTo(ivPictureFrame)
        }
        
        textview.snp.remakeConstraints {
            $0.top.equalTo(ivPictureFrame.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        lblPlaceholder.snp.makeConstraints {
            $0.top.leading.equalTo(textview).offset(10)
        }
        lblPlaceholder.isHidden = !(textview.text?.isEmpty ?? true)
    }
}

// MARK: Bindable
extension CreateDiaryViewController {
    func bind() {
        bindPicture()
        bindTextView()
        bindButtons()
        bindText()
    }
    
    func bindPicture() {
        ivPicture.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.attachDiaryDrawing()
            }).disposed(by: bag)
    }
    
    func bindTextView() {
        textview.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.attachDiaryTextField()
            }).disposed(by: bag)
    }
    
    func bindButtons() {
        appBarTop.btnBack.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
#warning("저장하지 않고 뒤로가시겠습니까? 알려줘야되지 않을까")
                self.listener?.detachCreateDiary()
            }).disposed(by: bag)
        
        appBarTop.btnCompleted.rx.tap
            .subscribe(onNext: { [weak self] _ in
#warning("완료 로직")
                self?.listener?.detachCreateDiary()
            }).disposed(by: bag)
    }
    
    func bindText() {
        listener?.diaryText
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.textview.setAttributedText(text)
                self.lblPlaceholder.isHidden = !text.isEmpty
            }).disposed(by: bag)
    }
}
