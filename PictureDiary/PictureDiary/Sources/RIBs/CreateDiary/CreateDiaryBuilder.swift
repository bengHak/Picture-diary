//
//  CreateDiaryBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxRelay

protocol CreateDiaryDependency: Dependency { }

final class CreateDiaryComponent: Component<CreateDiaryDependency>,
                                  DiaryTextFieldDependency,
                                  DiaryDrawingDependency,
                                  VanishingCompletionDependency {
    var drawingImage: BehaviorRelay<UIImage?>
    var drawingData: BehaviorRelay<Data?>
    var diaryText: BehaviorRelay<String>
    var labelText: String { "오늘의 일기가 저장되었어요!" }

    init(
        dependency: CreateDiaryDependency,
        drawingImage: BehaviorRelay<UIImage?>,
        drawingData: BehaviorRelay<Data?>,
        diaryText: BehaviorRelay<String>
    ) {
        self.drawingImage = drawingImage
        self.drawingData = drawingData
        self.diaryText = diaryText
        super.init(dependency: dependency)
    }

}

// MARK: - Builder

protocol CreateDiaryBuildable: Buildable {
    func build(withListener listener: CreateDiaryListener) -> CreateDiaryRouting
}

final class CreateDiaryBuilder: Builder<CreateDiaryDependency>, CreateDiaryBuildable {

    override init(dependency: CreateDiaryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateDiaryListener) -> CreateDiaryRouting {
        let drawingImage = BehaviorRelay<UIImage?>(value: nil)
        let drawingData = BehaviorRelay<Data?>(value: nil)
        let diaryText = BehaviorRelay<String>(value: "")

        let component = CreateDiaryComponent(
            dependency: dependency,
            drawingImage: drawingImage,
            drawingData: drawingData,
            diaryText: diaryText
        )

        let viewController = CreateDiaryViewController(
            drawingImage: drawingImage,
            diaryText: diaryText
        )

        let diaryRepository = DiaryRepository()
        let interactor = CreateDiaryInteractor(
            presenter: viewController,
            diaryRepository: diaryRepository
        )
        interactor.listener = listener

        let diaryTextFieldBuilder = DiaryTextFieldBuilder(dependency: component)
        let diaryDrawingBuilder = DiaryDrawingBuilder(dependency: component)
        let vanishingCompletionBuilder = VanishingCompletionBuilder(dependency: component)
        return CreateDiaryRouter(
            interactor: interactor,
            viewController: viewController,
            diaryTextFieldBuilder: diaryTextFieldBuilder,
            diaryDrawingBuilder: diaryDrawingBuilder,
            vanishingCompletionBuilder: vanishingCompletionBuilder
        )
    }
}
