//
//  DiaryDetailInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/05/11.
//

import RIBs
import RxSwift

protocol DiaryDetailRouting: ViewableRouting { }

protocol DiaryDetailPresentable: Presentable {
    var listener: DiaryDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DiaryDetailListener: AnyObject {
    func detachDiaryDetail()
}

final class DiaryDetailInteractor: PresentableInteractor<DiaryDetailPresentable>, DiaryDetailInteractable, DiaryDetailPresentableListener {

    weak var router: DiaryDetailRouting?
    weak var listener: DiaryDetailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: DiaryDetailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func detachDiaryDetail() {
        listener?.detachDiaryDetail()
    }
    
    func tapShareButton(_ imageData: Data, _ completionHandler: @escaping (Bool) -> Void) {
        let urlString = "instagram-stories://share?source_application=kr.co.byunghak.PictureDiary"
        let pasteboardItems : [String:Any] = [
           "com.instagram.sharedSticker.stickerImage": imageData,
           "com.instagram.sharedSticker.backgroundTopColor" : "#EDEDED",
           "com.instagram.sharedSticker.backgroundBottomColor" : "#EDEDED",

        ]
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)]
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            completionHandler(true)
        } else {
            #warning("인스타그램이 설치되지 않았을 경우")
            completionHandler(false)
        }
    }
}
