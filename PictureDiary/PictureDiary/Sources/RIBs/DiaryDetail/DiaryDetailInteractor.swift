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
}

protocol DiaryDetailListener: AnyObject {
    func detachDiaryDetail()
}

final class DiaryDetailInteractor: PresentableInteractor<DiaryDetailPresentable>,
                                   DiaryDetailInteractable,
                                   DiaryDetailPresentableListener {

    weak var router: DiaryDetailRouting?
    weak var listener: DiaryDetailListener?

    override init(presenter: DiaryDetailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func detachDiaryDetail() {
        listener?.detachDiaryDetail()
    }

    func tapShareButton(_ imageData: Data) {
        let urlString = "instagram-stories://share?source_application=kr.co.byunghak.PictureDiary"
        let pasteboardItems: [String: Any] = [
           "com.instagram.sharedSticker.stickerImage": imageData,
           "com.instagram.sharedSticker.backgroundTopColor": "#EDEDED",
           "com.instagram.sharedSticker.backgroundBottomColor": "#EDEDED"
        ]
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        } else {
            if let url = URL(string: "itms-apps://apps.apple.com/app/id389801252") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
