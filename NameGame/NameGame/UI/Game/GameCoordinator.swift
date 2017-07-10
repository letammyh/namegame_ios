//
//  GameCoordinator.swift
//  NameGame
//
//  Created by Tammy Le on 6/27/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

final class GameCoordinator: Coordinator {
    
    private(set) var isStarted: Bool
    fileprivate let store: Store<AppState>
    fileprivate let container: UINavigationController
    private(set) var controller: GameViewController?
    
    weak var coordinatorEventObserver: CoordinatorEventObserver?
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
        
        let workflow = GameWorkflow(store: store)
        workflow.presentationEventObserver = self
        
        let controller = GameViewController.make()
        controller.lifecycleObserver = self
        controller.inject(workflow)
        self.controller = controller
        container.pushViewController(controller, animated: true)
        
        store.subscribe(self) { subscription in
            subscription.select { state in
                return state.gameState
            }
        }
    }
    
}

extension GameCoordinator: ViewLifecycleObserver {
    
    func viewWillAppear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.subscribe(controller) { state in
            state.select(GameViewModel.init)
        }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.unsubscribe(controller)
        store.unsubscribe(self)
        
        // If the user presses back button during game
        if !container.viewControllers.contains(controller) {
            coordinatorEventObserver?.willStop(coordinator: self)
            currentCoordinator = nil
        }
    }
    
}

extension GameCoordinator: GameWorkflowPresentationEventObserver {
    
    func returnToMainMenu() {
        container.popViewController(animated: true)
    }
    
    func presentEndGameCoordinator() {
        let coordinator = EndGameCoordinator(store: store, container: container)
        currentCoordinator = coordinator
        coordinator.start()
    }
    
}

extension GameCoordinator: StoreSubscriber {
    
    func newState(state: GameState?) {
        guard state == nil else {
            return
        }
        
        store.unsubscribe(self)
    }
    
}
