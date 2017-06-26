//
//  Coordinator.swift
//  NameGame
//
//  Created by Tammy Le on 6/22/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

protocol Coordinator {
    var isStarted: Bool { get }
    func start()
}

protocol CoordinatorEventObserver: class {
    func willStop(coordinator: Coordinator)
}
