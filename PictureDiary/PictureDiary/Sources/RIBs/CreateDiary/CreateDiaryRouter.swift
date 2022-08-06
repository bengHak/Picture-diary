//
//  CreateDiaryRouter.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import RIBs
import PencilKit

protocol CreateDiaryInteractable: Interactable,
                                  DiaryTextFieldListener,
                                  DiaryDrawingListener,
                                  VanishingCompletionListener {
    var router: CreateDiaryRouting? { get set }
    var listener: CreateDiaryListener? { get set }
}

protocol CreateDiaryViewControllable: ViewControllable { }

final class CreateDiaryRouter: ViewableRouter<CreateDiaryInteractable, CreateDiaryViewControllable>,
                               CreateDiaryRouting {

    init(
        interactor: CreateDiaryInteractable,
        viewController: CreateDiaryViewControllable,
        diaryTextFieldBuilder: DiaryTextFieldBuildable,
        diaryDrawingBuilder: DiaryDrawingBuildable,
        vanishingCompletionBuilder: VanishingCompletionBuildable
    ) {
        self.diaryTextFieldBuilder = diaryTextFieldBuilder
        self.diaryDrawingBuilder = diaryDrawingBuilder
        self.vanishingCompletionBuilder = vanishingCompletionBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func cleanupViews() {
        detachDiaryDrawing()
        detachDiaryTextField()
        detachVanishingCompletion()
    }

    // MARK: - DiaryTextField
    func attachDiaryTextField() {
        let router = diaryTextFieldBuilder.build(withListener: interactor)
        diaryTextFieldRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.modalPresentationStyle = .fullScreen
        self.viewControllable.uiviewController.present(vc, animated: true)
    }

    func detachDiaryTextField() {
        if let router = diaryTextFieldRouter {
            self.viewControllable.uiviewController.dismiss(animated: true)
            detachChild(router)
        }
    }

    // MARK: - DiaryDrawing
    func attachDiaryDrawing() {
        let router = diaryDrawingBuilder.build(withListener: interactor)
        diaryDrawingRouter = router
        attachChild(router)
        let vc = router.viewControllable.uiviewController
        vc.modalPresentationStyle = .overFullScreen
        self.viewControllable.uiviewController.present(vc, animated: true)
    }

    func detachDiaryDrawing() {
        if let router = diaryDrawingRouter {
            self.viewControllable.uiviewController.dismiss(animated: true)
            detachChild(router)
        }
    }

    // MARK: - VanishingCompletion
    func attachVanishingCompletion() {
        let router = vanishingCompletionBuilder.build(withListener: interactor)
        vanishingCompletionRouter = router
        attachChild(router)
        let vc = router.viewControllable.getFullScreenModalVC()
        self.viewControllable.uiviewController.present(vc, animated: true)
    }
    
    func detachVanishingCompletion() {
        if let router = vanishingCompletionRouter {
            self.viewControllable.uiviewController.dismiss(animated: true)
            detachChild(router)
        }
    }

    // MARK: - Private
    private let diaryTextFieldBuilder: DiaryTextFieldBuildable
    private var diaryTextFieldRouter: DiaryTextFieldRouting?
    
    private let diaryDrawingBuilder: DiaryDrawingBuildable
    private var diaryDrawingRouter: DiaryDrawingRouting?
    
    private let vanishingCompletionBuilder: VanishingCompletionBuildable
    private var vanishingCompletionRouter: VanishingCompletionRouting?
}
