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
    fileprivate var imageCache: ImageCache!
    
    weak var coordinatorEventObserver: CoordinatorEventObserver?
    
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
        
        let controller = GameViewController.make()
        let workflow = GameWorkflow(store: store)
        
        guard let gameState = store.state.gameState else {
            return
        }
        controller.inject(gameState.images)
        
        controller.lifecycleObserver = self
        controller.inject(workflow)
        self.controller = controller
        container.pushViewController(controller, animated: true)
        
    }
    
    func inject(_ imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
}

extension GameCoordinator: ViewLifecycleObserver {
    
    func viewWillAppear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.subscribe(controller) { state in
            state.select(GameViewModel.init) }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        guard let controller = self.controller else {
            return
        }
        
        store.unsubscribe(controller)
        
        // If the user presses back button during game
        if !container.viewControllers.contains(controller) {
            coordinatorEventObserver?.willStop(coordinator: self)
        }
    }
    
}
