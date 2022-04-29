//
//  DiaryDrawingBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import RIBs
import RxRelay

protocol DiaryDrawingDependency: Dependency {
    var drawingImage: BehaviorRelay<UIImage?> { get }
    var drawingData: BehaviorRelay<Data?> { get }
}

final class DiaryDrawingComponent: Component<DiaryDrawingDependency> {
    fileprivate var drawingImage: BehaviorRelay<UIImage?> { dependency.drawingImage }
    fileprivate var drawingData: BehaviorRelay<Data?> { dependency.drawingData }
}

// MARK: - Builder

protocol DiaryDrawingBuildable: Buildable {
    func build(withListener listener: DiaryDrawingListener) -> DiaryDrawingRouting
}

final class DiaryDrawingBuilder: Builder<DiaryDrawingDependency>, DiaryDrawingBuildable {

    override init(dependency: DiaryDrawingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DiaryDrawingListener) -> DiaryDrawingRouting {
        let component = DiaryDrawingComponent(dependency: dependency)
        let viewController = DiaryDrawingViewController(
            image: component.drawingImage,
            data: component.drawingData
        )
        let interactor = DiaryDrawingInteractor(presenter: viewController)
        interactor.listener = listener
        return DiaryDrawingRouter(interactor: interactor, viewController: viewController)
    }
}
