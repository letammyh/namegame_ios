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
    private(set) var userRecordService: UserRecordService!
    
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
        controller.lifecycleObserver = self
        container.viewControllers = [controller]
    }
    
    func inject(_ service: UserRecordService) {
        self.userRecordService = service
    }
    
}

extension MenuCoordinator: ViewLifecycleObserver {
}

