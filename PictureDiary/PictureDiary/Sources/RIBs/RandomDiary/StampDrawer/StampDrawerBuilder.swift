//
//  StampDrawerBuilder.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs
import RxRelay

protocol StampDrawerDependency: Dependency {
    var selectedStamp: BehaviorRelay<StampType?> { get }
    var stampPosition: BehaviorRelay<StampPosition> { get }
}

final class StampDrawerComponent: Component<StampDrawerDependency> {
    fileprivate var selectedStamp: BehaviorRelay<StampType?> { dependency.selectedStamp }
    fileprivate var stampPosition: BehaviorRelay<StampPosition> { dependency.stampPosition }
}

// MARK: - Builder

protocol StampDrawerBuildable: Buildable {
    func build(withListener listener: StampDrawerListener) -> StampDrawerRouting
}

final class StampDrawerBuilder: Builder<StampDrawerDependency>, StampDrawerBuildable {

    override init(dependency: StampDrawerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: StampDrawerListener) -> StampDrawerRouting {
        let component = StampDrawerComponent(dependency: dependency)
        let viewController = StampDrawerViewController(
            selectedStamp: component.selectedStamp,
            stampPosition: component.stampPosition
        )
        let interactor = StampDrawerInteractor(presenter: viewController)
        interactor.listener = listener
        return StampDrawerRouter(interactor: interactor, viewController: viewController)
    }
}
