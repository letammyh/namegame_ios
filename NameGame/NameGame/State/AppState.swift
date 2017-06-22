//
//  AppState.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    
    var userRecords: Loading<[UserRecord]>
    var gameState: GameState?
    
    init() {
        userRecords = .notAsked
        gameState = nil
    }
    
}
