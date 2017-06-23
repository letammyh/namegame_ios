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
    let store: Store<AppState>
    let container: UINavigationController
    private(set) var controller: MenuViewController?
    
    init(store: Store<AppState>, container: UINavigationController) {
        self.isStarted = false
        self.store = store
        self.container = container
        self.controller = nil
    }
    
    func start() {
        guard !isStarted else {
            return
        }
        
        let controller = MenuViewController.make()
        let workflow = MenuWorkflow(store: store)
        workflow.inject(UserRecordService.shared)
        workflow.refreshUserRecords()
        workflow.coordinatorHandler = self
        controller.inject(workflow)
        container.viewControllers = [controller]
    }
    
}

extension MenuCoordinator: CoordinatorHandler {
    
    func createUserGridCoordinator() {
        let coordinator = UserGridCoordinator(store: store, container: container)
        coordinator.start()
    }
    
    func createGameCoordinator() {
        // TODO
    }
}

