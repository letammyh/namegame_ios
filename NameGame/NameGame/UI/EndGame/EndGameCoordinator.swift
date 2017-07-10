//
//  EndGameCoordinator.swift
//  NameGame
//
//  Created by Tammy Le on 7/5/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

final class EndGameCoordinator: Coordinator {
    
    private(set) var isStarted: Bool
    fileprivate let store: Store<AppState>
    fileprivate let container: UINavigationController
    fileprivate(set) var controller: EndGameViewController?
    
    weak var coordinatorEventObserver: CoordinatorEventObserver?
    
    init(store: Store<AppState>, container: UINavigationController) {
        self.isStarted = false
        self.store = store
        self.container = container
        self.controller = nil
    }
    
    func start() {
        guard !isStarted, let gameState = store.state.gameState else {
            return
        }
        
        let workflow = EndGameWorkflow(store: store)
        workflow.presentationEventObserver = self
        
        let controller = EndGameViewController.make()
        controller.inject(workflow)
        controller.inject(gameState.score)
        self.controller = controller
        container.pushViewController(controller, animated: true)
    }
    
}

extension EndGameCoordinator: EndGameWorkflowPresentationEventObserver {
    
    func presentMainMenu() {
        container.popToRootViewController(animated: true)
    }
    
    func presentNewGame() {
        container.popViewController(animated: true)
    }
    
}
