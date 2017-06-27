//
//  MenuCoordinator.swift
//  NameGame
//
//  Created by Tammy Le on 6/22/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

final class MenuCoordinator: Coordinator {
    
    private(set) var isStarted: Bool
    fileprivate let store: Store<AppState>
    fileprivate let container: UINavigationController
    private(set) var controller: MenuViewController?
    fileprivate var imageCache: ImageCache!
    
    fileprivate(set) var currentCoordinator: Coordinator?
    
    init(store: Store<AppState>, container: UINavigationController) {
        self.isStarted = false
        self.store = store
        self.container = container
        self.controller = nil
        self.currentCoordinator = nil
    }
    
    func start() {
        guard !isStarted else {
            return
        }
        
        let workflow = MenuWorkflow(store: store)
        let controller = MenuViewController.make()
        workflow.inject(UserRecordService.shared)
        workflow.refreshUserRecords()
        workflow.presentationEventObserver = self
        controller.eventHandler = workflow
        container.pushViewController(controller, animated: true)
    }
    
    func inject(_ imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
}

extension MenuCoordinator: MenuWorkflowPresentationEventObserver {
    
    func presentUserGridCoordinator() {
        let coordinator = UserGridCoordinator(store: store, container: container)
        coordinator.inject(imageCache)
        coordinator.controllerEventObserver = self
        currentCoordinator = coordinator
        coordinator.start()
    }
    
    func presentGameCoordinator() {
        // TODO
    }
    
}

extension MenuCoordinator: CoordinatorEventObserver {
    
    func willStop(coordinator: Coordinator) {
        currentCoordinator = nil
    }

}

