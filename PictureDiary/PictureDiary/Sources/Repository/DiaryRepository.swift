//
//  DiaryRepository.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/20.
//

import Foundation
import RxSwift
import Moya

protocol DiaryRepositoryProtocol {
    func fetchDiary(id: Int) -> Observable<ModelDiaryResponse>
    func fetchDiaryList() -> Observable<[ModelDiaryResponse]>
    func uploadDiary(content: String, weather: WeatherType, imageURL: String) -> Observable<ModelDiaryResponse>
    func uploadDiaryImage(data: Data) -> Observable<ModelDiaryImageUploadResponse>
}

final class DiaryRepository: DiaryRepositoryProtocol {
    
    private let provider: MoyaProvider<DiaryAPI>
    
    init() {
        provider = MoyaProvider<DiaryAPI>()
    }
    
    
    func fetchDiary(id: Int) -> Observable<ModelDiaryResponse> {
        provider.rx.request(.fetchDiary(id: id))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode(ModelDiaryResponse.self, from: $0) }
            .asObservable()
            .catch { error in
                print(error)
                return Observable.error(DiaryError.fetchDiaryError)
            }
    }
    
    func fetchDiaryList() -> Observable<[ModelDiaryResponse]> {
        provider.rx.request(.fetchDiaryList(lastDiaryId: -1, querySize: 100))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode([ModelDiaryResponse].self, from: $0) }
            .asObservable()
            .catch { error in
                print(error)
                return Observable.error(DiaryError.fetchDiaryListError)
            }
    }
    
    func uploadDiary(content: String, weather: WeatherType, imageURL: String) -> Observable<ModelDiaryResponse> {
        provider.rx.request(.uploadDiary(content: content, weather: weather, imageURL: imageURL))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode(ModelDiaryResponse.self, from: $0) }
            .asObservable()
            .catch { error in
                print(error)
                return Observable.error(DiaryError.uploadDiaryError)
            }
    }
    
    func uploadDiaryImage(data: Data) -> Observable<ModelDiaryImageUploadResponse> {
        provider.rx.request(.uploadDiaryImage(data: data))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .map { try JSONDecoder().decode(ModelDiaryImageUploadResponse.self, from: $0) }
            .asObservable()
            .catch { error in
                print(error)
                return Observable.error(DiaryError.uploadImageError)
            }
    }
}
