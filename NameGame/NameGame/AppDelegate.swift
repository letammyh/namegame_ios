//
//  AppDelegate.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let logger: StateLogger
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    lazy var store: Store<AppState> = {
        let store = Store<AppState>(
            reducer: AppReducer.handle(action:state:),
            state: AppState()
        )
        return store
    }()
    
    override init() {
        self.logger = StateLogger()
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = self.window, let navigationController = window.rootViewController as? UINavigationController else {
            preconditionFailure("Expected 'UINavigationController' as window root view controller.")
        }
        appCoordinator = AppCoordinator(store: store, container: navigationController)
        FilePath.createDirectories()
        
        return true
    }
    
}


