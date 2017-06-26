//
//  StateLogger.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import ReSwift

final class StateLogger: StoreSubscriber {
    
    enum LogLevel {
        case fullState
        case gameState
    }
    
    var logLevel: LogLevel = .fullState
    
    func newState(state: AppState) {
        switch logLevel {
        case .fullState:
            print("State: \(String(describing: state))")
        case .gameState:
            print("GameState: \(String(describing: state.gameState))")
        }
    }
    
}
