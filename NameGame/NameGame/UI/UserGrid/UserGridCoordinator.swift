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
    let store: Store<AppState>
    let container: UINavigationController
    private(set) var controller: UserGridViewController?
    
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

        let controller = UserGridViewController.make()
        controller.lifecycleObserver = self
        container.viewControllers = [controller]
    }
    

    
}

extension UserGridCoordinator: ViewLifecycleObserver {
}
