//
//  DiaryListViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs
import RxSwift
import RxCocoa
import RxGesture
import UIKit
import SnapKit
import Then

protocol DiaryListPresentableListener: AnyObject {
    func attachCreateDiary()
    func attachDiaryDetail(diaryId: Int)
    func fetchDiaryList()
    func attachRandomDiary()
    func attachSettings()
}

final class DiaryListViewController: UIViewController,
                                     DiaryListPresentable,
                                     DiaryListViewControllable {

    weak var listener: DiaryListPresentableListener?

    // MARK: - UI Properties
    /// 상단 앱바
    private let appBarTopView = AppBarTopView(appBarTopType: .main)

    /// 내 일기장 라벨
    private let lblTitle = UILabel().then {
        $0.text = "내 일기장"
        $0.font = .PretendardFont.h1.font()
        $0.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    }

    /// 일기장 리스트
    private var collectionView: UICollectionView!

    /// 아직 작성된 일기장이 없어요 뷰
    private let emptyDiaryView = EmptyDiaryListView()

    // MARK: - Properties
    private let bag = DisposeBag()
    private let diaryList: BehaviorRelay<[ModelDiaryResponse]>
    private let isRefreshNeed: BehaviorRelay<Bool>

    // MARK: - Lifecycles
    init(
        diaryList: BehaviorRelay<[ModelDiaryResponse]>,
        isRefreshNeed: BehaviorRelay<Bool>
    ) {
        self.diaryList = diaryList
        self.isRefreshNeed = isRefreshNeed
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
}

// MARK: BaseViewController
extension DiaryListViewController: BaseViewController {
    func configureView() {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat
        if UIScreen.main.traitCollection.userInterfaceIdiom == .phone {
            width = view.frame.width
        } else {
            width = 360
        }
        layout.itemSize = CGSize(width: width, height: 212)
        layout.minimumLineSpacing = 4.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier
        )

        [appBarTopView, lblTitle, emptyDiaryView, collectionView].forEach {
            view.addSubview($0)
        }
    }

    func configureSubviews() {
        appBarTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        lblTitle.snp.makeConstraints {
            $0.top.equalTo(appBarTopView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(22)
            $0.height.equalTo(28)
        }

        emptyDiaryView.snp.makeConstraints {
            $0.center.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
        emptyDiaryView.isHidden = false

        collectionView.snp.makeConstraints {
            $0.top.equalTo(lblTitle.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.isHidden = true
    }
}

// MARK: Bind
extension DiaryListViewController {
    func bind() {
        bindButtons()
        bindCollectionView()
        bindRefreshFlag()
    }

    func bindButtons() {
        emptyDiaryView.btnCreateDiary.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.attachCreateDiary()
            }).disposed(by: emptyDiaryView.bag)

        appBarTopView.btnCreate.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.attachCreateDiary()
            }).disposed(by: bag)

        appBarTopView.btnPeople.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.attachRandomDiary()
            }).disposed(by: bag)
    }

    func bindCollectionView() {
        diaryList
            .bind(to: collectionView.rx.items(
                cellIdentifier: DiaryCollectionViewCell.identifier,
                cellType: DiaryCollectionViewCell.self
            )) { _, item, cell in
                cell.setData(
                    id: item.diaryId ?? -1,
                    date: item.getDate(),
                    weather: item.getWeather(),
                    drawingImageURL: item.imageUrl,
                    drawingData: item.imageData,
                    didStamp: item.stamped ?? false
                )
            }.disposed(by: bag)

        collectionView.rx.modelSelected(ModelDiaryResponse.self)
            .subscribe(onNext: { [weak self] diary in
                guard let self = self,
                      let id = diary.diaryId  else {
                    return
                }
                self.listener?.attachDiaryDetail(diaryId: id)
            }).disposed(by: bag)

        diaryList
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                if items.count == 0 {
                    self.collectionView.isHidden = true
                    self.emptyDiaryView.isHidden = false
                } else {
                    self.collectionView.isHidden = false
                    self.emptyDiaryView.isHidden = true
                }
                self.collectionView.reloadData()
            }).disposed(by: bag)
    }

    private func bindRefreshFlag() {
        self.isRefreshNeed
            .bind(onNext: { [weak self] isNeed in
                guard let self = self, isNeed else {
                    return
                }
                self.listener?.fetchDiaryList()
            }).disposed(by: bag)
    }
}
