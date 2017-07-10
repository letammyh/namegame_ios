//
//  UserGridCoordinator.swift
//  NameGame
//
//  Created by Tammy Le on 6/22/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

final class UserGridCoordinator: Coordinator {
    
    private(set) var isStarted: Bool
    fileprivate let store: Store<AppState>
    fileprivate let container: UINavigationController
    private(set) var controller: UserGridViewController?
    private var imageCache: ImageCache!
    
    weak var eventObserver: CoordinatorEventObserver?
    
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

        let workflow = UserGridWorkflow()
        workflow.presentationEventObserver = self
        
        let controller = UserGridViewController.make()
        controller.inject(imageCache)
        controller.lifecycleObserver = self
        controller.inject(workflow)
        self.controller = controller
        container.pushViewController(controller, animated: true)
        
    }
    
    func inject(_ imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
}

extension UserGridCoordinator: ViewLifecycleObserver {
    
    func viewWillAppear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.subscribe(controller) { state in
            state.select(UserGridViewModel.init)
        }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.unsubscribe(controller)
        if !container.viewControllers.contains(controller) {
            eventObserver?.willStop(coordinator: self)
        }

    }
    
}

extension UserGridCoordinator: UserGridWorkflowPresentationEventObserver {
    
    func returnToMainMenu() {
        container.popViewController(animated: true)
    }
}
