//
//  CreateDiaryInteractor.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxSwift
import RxRelay
import Darwin

protocol CreateDiaryRouting: ViewableRouting {
    func cleanupViews()
    func attachDiaryTextField()
    func detachDiaryTextField()
    func attachDiaryDrawing()
    func detachDiaryDrawing()
    func attachVanishingCompletion()
    func detachVanishingCompletion()
}

protocol CreateDiaryPresentable: Presentable {
    var listener: CreateDiaryPresentableListener? { get set }
    func configureScrollView()
}

protocol CreateDiaryListener: AnyObject {
    func detachCreateDiary()
    func setRefreshNeed()
}

final class CreateDiaryInteractor: PresentableInteractor<CreateDiaryPresentable>,
                                   CreateDiaryInteractable,
                                   CreateDiaryPresentableListener {
    weak var router: CreateDiaryRouting?
    weak var listener: CreateDiaryListener?
    private var date: Date?
    private var content: String?
    private var weather: WeatherType?
    private var drawingImageData: Data?
    private let diaryRepository: DiaryRepositoryProtocol
    private let uploadedImageURL: BehaviorRelay<String>
    private let bag: DisposeBag

    init(
        presenter: CreateDiaryPresentable,
        diaryRepository: DiaryRepositoryProtocol
    ) {
        self.diaryRepository = diaryRepository
        self.uploadedImageURL = BehaviorRelay<String>(value: "")
        self.bag = DisposeBag()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() { super.didBecomeActive() }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }

    func tapDrawingCompleteButton(
        date: Date,
        weather: WeatherType,
        drawing: Data,
        content: String
    ) {
        bindUploadedImageURL()

        self.content = content
        self.weather = weather
        self.date = date
        self.drawingImageData = drawing

        diaryRepository.uploadDiaryImage(data: drawing)
            .subscribe(onNext: { [weak self] response in
                guard let self = self,
                      let imageUrl = response.imageUrl else {
                    return
                }
                self.uploadedImageURL.accept(imageUrl)
            }).disposed(by: self.bag)
    }

    func tapCancleButton() { listener?.detachCreateDiary() }

    func routeToDiaryTextField() { router?.attachDiaryTextField() }

    func detachDiaryTextField() {
        router?.detachDiaryTextField()
        presenter.configureScrollView()
    }

    func routeToDiaryDrawing() { router?.attachDiaryDrawing() }

    func detachDiaryDrawing() { router?.detachDiaryDrawing() }

    func routeToVanishingCompletion() { router?.attachVanishingCompletion() }

    func detachCompletionView() {
        router?.detachVanishingCompletion()
        listener?.setRefreshNeed()
        listener?.detachCreateDiary()
    }

    // MARK: - Bind
    private func bindUploadedImageURL() {
        uploadedImageURL
            .bind(onNext: { [weak self] imageUrl in
                guard let self = self else { return }
                self.uploadDiary(urlString: imageUrl)
            }).disposed(by: bag)
    }

    private func uploadDiary(urlString: String) {
        guard !urlString.isEmpty else {
            return
        }

        self.diaryRepository.uploadDiary(
            content: self.content!,
            weather: self.weather!,
            imageURL: urlString
        ).subscribe(onNext: { [weak self] response in
            guard let self = self,
                  let diaryId = response.diaryId else {
                print("🔴 일기 저장 실패")
                return
            }
            self.cacheDiary(diaryId: diaryId, imageUrl: urlString)
        }).disposed(by: bag)
    }

    private func cacheDiary(diaryId: Int, imageUrl: String) {
        let diary: ModelDiaryResponse?
        if #available(iOS 15.0, *) {
            diary = ModelDiaryResponse(
                createdDate: self.date?.ISO8601Format(
                    .iso8601
                        .year()
                        .year()
                        .month()
                        .day()
                        .dateSeparator(.dash)
                        .time(includingFractionalSeconds: true)
                        .timeSeparator(.colon)
                ),
                diaryId: diaryId,
                imageUrl: imageUrl,
                imageData: nil,
                weather: self.weather?.getString(),
                content: self.content,
                stampList: nil,
                stamped: false
            )
        } else {
            diary = nil
        }

        guard let diary = diary else {
            print("⚠️ iOS 15 이상만 지원합니다.")
            return
        }

        CDPictureDiaryHandler.shared.saveDiary(
            diaryResponse: diary,
            drawing: self.drawingImageData
        ) { [weak self] _, success in
            if success {
                guard let self = self else { return }
                print("🟢 일기 저장 성공")
                self.routeToVanishingCompletion()
            } else {
                print("🔴 일기 저장 실패")
            }
        }
    }

}
