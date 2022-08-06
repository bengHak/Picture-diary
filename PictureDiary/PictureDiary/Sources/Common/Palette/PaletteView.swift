//
//  PaletteView.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/13.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxRelay

class PaletteView: UIView {

    // MARK: - UI Properties
    /// 상단 경계선
    private let upperBorder = UIView().then {
        $0.backgroundColor = UIColor.appColor(.grayscale300)
    }

    /// 물감 컬렉션 뷰
    private var collectionView: UICollectionView!

    /// 펜 굵기 슬라이더
    private let penThicknessSlider = UISlider().then {
        $0.setThumbImage(UIImage(named: "ic_slider_button"), for: .normal)
        $0.minimumTrackTintColor = .init(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        $0.maximumTrackTintColor = .init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }

    // MARK: - Properties
    private let bag = DisposeBag()
    private let colors: [UIColor]
    var selectedColorIndex = BehaviorRelay<Int>(value: PaletteColorType.white.hashValue)
    var selectedStrokeSize = BehaviorRelay<Float>(value: 10.0)

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        var colorList: [UIColor] = []
        PaletteColorType.allCases.forEach {
            colorList.append(UIColor.paletteColor($0))
        }
        colors = colorList
        super.init(frame: frame)

        setUI()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    func setUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize(width: 48, height: 48)
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 148)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PaletteColorCell.self, forCellWithReuseIdentifier: PaletteColorCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false

        penThicknessSlider.minimumValue = 10
        penThicknessSlider.maximumValue = 150
        penThicknessSlider.value = 10

        addSubview(collectionView)
        addSubview(penThicknessSlider)
        addSubview(upperBorder)

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }

        penThicknessSlider.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        upperBorder.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        backgroundColor = .white
    }

    private func bind() {
        Observable.of(colors)
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: PaletteColorCell.identifier,
                    cellType: PaletteColorCell.self
                )
            ) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.setColor(element, isChosen: row == self.selectedColorIndex.value)
            }.disposed(by: bag)

        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.selectedColorIndex.accept(index.row)
                self.collectionView.reloadData()
            }).disposed(by: bag)

        penThicknessSlider.rx.value
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.selectedStrokeSize.accept(value)
            }).disposed(by: bag)
    }
}
