//
//  CreateDiaryViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then

protocol CreateDiaryPresentableListener: AnyObject {
    func detachCreateDiary()
}

final class CreateDiaryViewController: UIViewController, CreateDiaryPresentable, CreateDiaryViewControllable {

    weak var listener: CreateDiaryPresentableListener?
    
    // MARK: - UI Properties
    /// App bar top
    private let appBarTop = AppBarTopView(appBarTopType: .completion)
    
    /// 날짜 라벨
    private let lblDate = UILabel().then {
        $0.text = "2022년 3월 18일"
        $0.font = .defaultFont(type: .kyobo, size: 14)
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
    private let ivPictureFrame = UIImageView(image: UIImage(named: "img_picture_frame"))
    
    /// 그림 이미지
    private let ivPicture = UIImageView()
    
    /// 밑줄 uiview 스택
    private let stackUnderline = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 34.05
    }
    
    /// 텍스트 일기장
    private let textview = UITextView().then {
        $0.font = .defaultFont(type: .kyobo, size: 16)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 36 // 20 + 16
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        $0.attributedText = NSAttributedString(string: "", attributes: attributes)
    }
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var currentNumberOfLines = 0
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureView()
        configureSubviews()
        bind()
    }
    
    // MARK: - Helpers
    func addNewUnderline() {
        let ivUnderline = UIImageView(image: UIImage(named: "img_underline"))
        self.stackUnderline.addArrangedSubview(ivUnderline)
        ivUnderline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: BaseViewController
extension CreateDiaryViewController: BaseViewController {
    func configureView() {
        [ivSunny, ivCloudy, ivRain, ivSnow].forEach { stackWeather.addArrangedSubview($0) }
        [appBarTop, lblDate, stackWeather, ivPictureFrame, ivPicture, stackUnderline, textview].forEach { view.addSubview($0) }
    }
    
    func configureSubviews() {
        appBarTop.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        lblDate.snp.makeConstraints {
            $0.top.equalTo(appBarTop.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        stackWeather.snp.makeConstraints {
            $0.centerY.equalTo(lblDate)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        ivPictureFrame.snp.makeConstraints {
            $0.top.equalTo(lblDate.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            let ratio = ivPictureFrame.image?.getImageRatio()
            let w = view.bounds.width - 40
            let h = Float(w) * Float(ratio!)
            $0.height.equalTo(h)
        }
        
        textview.snp.makeConstraints {
            $0.top.equalTo(ivPictureFrame.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        stackUnderline.snp.makeConstraints {
            $0.top.equalTo(ivPictureFrame.snp.bottom).offset(37)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        for _ in 0..<5 { addNewUnderline() }
    }
}

// MARK: Bindable
extension CreateDiaryViewController {
    func bind() {
        bindTextView()
        bindButtons()
    }
    
    func bindTextView() {
        textview.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let newNumberOfLines = self.textview.numberOfLine()
                if newNumberOfLines > 5 {
                    if self.currentNumberOfLines < newNumberOfLines {
                        self.addNewUnderline()
                    } else if self.currentNumberOfLines > newNumberOfLines {
                        self.stackUnderline.arrangedSubviews[newNumberOfLines-1].removeFromSuperview()
                    }
                }
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
            .subscribe(onNext: { _ in
                #warning("완료 로직")
                self.listener?.detachCreateDiary()
            }).disposed(by: bag)
    }
}
