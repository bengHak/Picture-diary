//
//  DiaryListViewController.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/07.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then

protocol DiaryListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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
    }
    
    /// 일기장 리스트
    private var collectionView: UICollectionView!
    
    /// 아직 작성된 일기장이 없어요 뷰
    private let emptyDiaryView = EmptyDiaryListView()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        configureSubviews()
    }
    
    // MARK: - Helpers
}

// MARK: BaseViewController
extension DiaryListViewController: BaseViewController {
    func configureView() {
        let layout = UICollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier)
        
        [appBarTopView, lblTitle, emptyDiaryView, collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    func configureSubviews() {
        appBarTopView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        lblTitle.snp.makeConstraints {
            $0.top.equalTo(appBarTopView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(22)
        }
        
        emptyDiaryView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        emptyDiaryView.isHidden = true
        
        collectionView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension DiaryListViewController {
    func bind() {
        bindButtons()
        bindCollectionView()
    }
    
    func bindButtons() {
        
    }
    
    func bindCollectionView() {
        
    }
}
