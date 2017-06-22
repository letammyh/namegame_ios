//
//  AppReducer.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import ReSwift

enum AppAction: Action {
    case setUserRecords(Loading<[UserRecord]>)
    case setGameState(GameState)
}

final class AppReducer {
    
    class func handle(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        if let action = action as? AppAction {
            switch action {
            case .setUserRecords(let loadingStatus):
                state.userRecords = loadingStatus
            case .setGameState(let gameState):
                state.gameState = gameState 
            }
        } else {
            state = GameReducer.handle(action: action, state: state)
        }
        
        return state 
    }
}
