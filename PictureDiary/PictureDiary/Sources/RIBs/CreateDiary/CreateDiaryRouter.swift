//
//  CreateDiaryRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs

protocol CreateDiaryInteractable: Interactable,
                                  DiaryTextFieldListener,
                                  DiaryDrawingListener {
    var router: CreateDiaryRouting? { get set }
    var listener: CreateDiaryListener? { get set }
}

protocol CreateDiaryViewControllable: ViewControllable { }

final class CreateDiaryRouter: ViewableRouter<CreateDiaryInteractable, CreateDiaryViewControllable>, CreateDiaryRouting {

    init(
        interactor: CreateDiaryInteractable,
        viewController: CreateDiaryViewControllable,
        diaryTextFieldBuilder: DiaryTextFieldBuildable,
        diaryDrawingBuilder: DiaryDrawingBuildable
    ) {
        self.diaryTextFieldBuilder = diaryTextFieldBuilder
        self.diaryDrawingBuilder = diaryDrawingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - DiaryTextField
    func routeToDiaryTextField() {
        let router = diaryTextFieldBuilder.build(withListener: interactor)
        diaryTextFieldRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        let nav = self.viewControllable.uiviewController.navigationController
        nav?.pushViewController(vc, animated: true)
    }
    
    func detachDiaryTextField() {
        if let router = diaryTextFieldRouter {
            detachChild(router)
            let nav = router.viewControllable.uiviewController.navigationController
            nav?.popViewController(animated: true)
        }
    }
    
    // MARK: - DiaryDrawing
    func routeToDiaryDrawing() {
        let router = diaryDrawingBuilder.build(withListener: interactor)
        diaryDrawingRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        let nav = self.viewControllable.uiviewController.navigationController
        nav?.pushViewController(vc, animated: true)
    }
    
    func detachDiaryDrawing() {
        if let router = diaryDrawingRouter {
            detachChild(router)
            let nav = router.viewControllable.uiviewController.navigationController
            nav?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private
    private let diaryTextFieldBuilder: DiaryTextFieldBuildable
    private var diaryTextFieldRouter: DiaryTextFieldRouting?
    
    private let diaryDrawingBuilder: DiaryDrawingBuildable
    private var diaryDrawingRouter: DiaryDrawingRouting?
}
