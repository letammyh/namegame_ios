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
    private var userRecordService: UserRecordService!
    
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

        let menuWorkflow = MenuWorkflow(store: store)
        menuWorkflow.inject(userRecordService)
        menuWorkflow.refreshUserRecords()
        store.subscribe(menuWorkflow) { state in
            state.select { appState in
                return appState.gameState
            }
        }
        menuWorkflow.presentationEventObserver = self
        
        let gamePrepWorkflow = GamePrepWorkflow(store: store)
        gamePrepWorkflow.inject(imageCache)
        menuWorkflow.gamePrepWorkflow = gamePrepWorkflow
        
        let controller = MenuViewController.make()
        controller.inject(menuWorkflow)
        controller.lifecycleObserver = self
        self.controller = controller
        container.pushViewController(controller, animated: true)
    }
    
    func inject(_ imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
    func inject(_ userRecordService: UserRecordService) {
        self.userRecordService = userRecordService
    }
    
}

extension MenuCoordinator: MenuWorkflowPresentationEventObserver {
    
    func presentUserGridCoordinator() {
        let coordinator = UserGridCoordinator(store: store, container: container)
        coordinator.inject(imageCache)
        coordinator.eventObserver = self
        currentCoordinator = coordinator
        coordinator.start()
    }
    
    func presentGameCoordinator() {
        let coordinator = GameCoordinator(store: store, container: container)
        coordinator.coordinatorEventObserver = self
        currentCoordinator = coordinator
        coordinator.start()
        store.dispatch(GameAction.setStatus(.playing))
    }
    
    func presentAlert(_ alert: UIAlertController) {
        guard let controller = controller else {
            return
        }

        controller.present(alert, animated: true, completion: nil)
    }
    
}

extension MenuCoordinator: CoordinatorEventObserver {
    
    func willStop(coordinator: Coordinator) {
        currentCoordinator = nil
        store.dispatch(AppAction.endGame)
    }

}

extension MenuCoordinator: ViewLifecycleObserver {
    
    func viewWillAppear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.subscribe(controller) { state in
            state.select(MenuViewModel.init)
        }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.unsubscribe(controller)
    }
}

