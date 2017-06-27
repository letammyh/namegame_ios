//
//  AppCoordinator.swift
//  NameGame
//
//  Created by Tammy Le on 6/22/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

final class AppCoordinator: Coordinator {
    
    private(set) var isStarted: Bool
    let store: Store<AppState>
    let container: UINavigationController
    
    var currentCoordinator: Coordinator?
    
    init(store: Store<AppState>, container: UINavigationController) {
        self.isStarted = false
        self.store = store
        self.container = container
        self.currentCoordinator = nil
    }
    
    func start() {
        guard !isStarted else {
            return
        }
        
        let coordinator = MenuCoordinator(store: store, container: container)
        coordinator.inject(ImageCache())
        currentCoordinator = coordinator
        coordinator.start()
        
        // create user service and inject into menu coordinator -- remove shared instance 
    }
    
}
