//
//  StateLogger.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import ReSwift

final class StateLogger: StoreSubscriber {
    
    func newState(state: AppState) {
//        print("GameState: \(String(describing: state.gameState))")print("GameState: \(String(describing: state.gameState))")
        print("State: \(String(describing: state))")
    }
    
}
