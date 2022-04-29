//
//  CreateDiaryBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import RxRelay

protocol CreateDiaryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateDiaryComponent: Component<CreateDiaryDependency>,
                                  DiaryTextFieldDependency,
                                  DiaryDrawingDependency {
    var drawingImage: BehaviorRelay<UIImage?>
    var drawingData: BehaviorRelay<Data?>
    
    init(
        dependency: CreateDiaryDependency,
        drawingImage: BehaviorRelay<UIImage?>,
        drawingData: BehaviorRelay<Data?>
    ) {
        self.drawingImage = drawingImage
        self.drawingData = drawingData
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
        
        let component = CreateDiaryComponent(
            dependency: dependency,
            drawingImage: drawingImage,
            drawingData: drawingData
        )
        
        let viewController = CreateDiaryViewController(
            drawingImage: drawingImage,
            drawingData: drawingData
        )
        
        let interactor = CreateDiaryInteractor(presenter: viewController)
        interactor.listener = listener
        
        let diaryTextFieldBuilder = DiaryTextFieldBuilder(dependency: component)
        let diaryDrawingBuilder = DiaryDrawingBuilder(dependency: component)
        return CreateDiaryRouter(interactor: interactor,
                                 viewController: viewController,
                                 diaryTextFieldBuilder: diaryTextFieldBuilder,
                                 diaryDrawingBuilder: diaryDrawingBuilder)
    }
}
