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
}

final class DiaryListViewController: UIViewController, DiaryListPresentable, DiaryListViewControllable {

    weak var listener: DiaryListPresentableListener?
    
    // MARK: - UI Properties
    /// 상단 앱바
    private let appBarTopView = AppBarTopView(appBarTopType: .main)
    
    /// 내 일기장 라벨
    private let lblTitle = UILabel().then {
        $0.text = "내 일기장"
        $0.font = .Pretendard(type: .semiBold, size: 24)
        $0.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    }
    
    /// 일기장 리스트
    private var collectionView: UICollectionView!
    
    /// 아직 작성된 일기장이 없어요 뷰
    private let emptyDiaryView = EmptyDiaryListView()
    
    // MARK: - Properties
    private let bag = DisposeBag()
    
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
extension DiaryListViewController: BaseViewController {
    func configureView() {
        let layout = UICollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier)
        
        [appBarTopView, lblTitle, emptyDiaryView].forEach {
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
        // emptyDiaryView.isHidden = true
        
//        collectionView.snp.makeConstraints {
//            $0.center.equalTo(view.safeAreaLayoutGuide)
//        }
//        collectionView.isHidden = true
    }
}

// MARK: Bind
extension DiaryListViewController {
    func bind() {
        bindButtons()
        bindCollectionView()
    }
    
    func bindButtons() {
        emptyDiaryView.btnCreateDiary.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.listener?.attachCreateDiary()
            }).disposed(by: emptyDiaryView.bag)
    }
    
    func bindCollectionView() {
        
    }
}
