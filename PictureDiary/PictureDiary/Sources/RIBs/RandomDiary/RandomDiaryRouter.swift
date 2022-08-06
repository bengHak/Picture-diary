//
//  RandomDiaryRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import RIBs

protocol RandomDiaryInteractable: Interactable,
                                  DiaryDetailListener,
                                  StampDrawerListener {
    var router: RandomDiaryRouting? { get set }
    var listener: RandomDiaryListener? { get set }
}

protocol RandomDiaryViewControllable: ViewControllable {
    func addDiaryDetail(_ viewController: UIViewController)
    func addStampDrawerView(_ viewController: UIViewController)
}

final class RandomDiaryRouter: ViewableRouter<RandomDiaryInteractable,
                                RandomDiaryViewControllable>,
                               RandomDiaryRouting {
    init(
        interactor: RandomDiaryInteractable,
        viewController: RandomDiaryViewControllable,
        diaryDetail: DiaryDetailBuildable,
        stampDrawer: StampDrawerBuildable
    ) {
        self.diaryDetailBuilder = diaryDetail
        self.stampDrawerBuilder = stampDrawer
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func cleanUpViews() {
        detachDiaryDetail()
        detachStampDrawer()
    }

    // MARK: - DiaryDetail
    func attachDiaryDetail() {
        guard diaryDetailRouter == nil else { return }
        let router = diaryDetailBuilder.build(withListener: interactor)
        let uiviewController = router.viewControllable.uiviewController
        viewController.addDiaryDetail(uiviewController)
        diaryDetailRouter = router
        attachChild(router)
    }

    func detachDiaryDetail() {
        guard let router = diaryDetailRouter else { return }
        detachChild(router)
        diaryDetailRouter = nil
    }

    // MARK: - Stamp
    func attachStampDrawer() {
        guard stampDrawerRouter == nil else { return }
        let router = stampDrawerBuilder.build(withListener: interactor)
        let uiviewController = router.viewControllable.uiviewController
        viewController.addStampDrawerView(uiviewController)
        stampDrawerRouter = router
        attachChild(router)
    }

    func detachStampDrawer() {
        guard let router = stampDrawerRouter else { return }
        detachChild(router)
        stampDrawerRouter = nil
    }

    // MARK: - Helper

    // MARK: - Private
    private var diaryDetailRouter: DiaryDetailRouting?
    private let diaryDetailBuilder: DiaryDetailBuildable

    private var stampDrawerRouter: StampDrawerRouting?
    private let stampDrawerBuilder: StampDrawerBuildable
}
