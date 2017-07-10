//
//  GameReducer.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import ReSwift
import UIKit

enum GameAction: Action {
    case setImages([UserRecord:UIImage])
    case setStatus(GameState.Status)
    case setQuestion(Question)
    case setDidFinishPlaying(Bool)
}

final class GameReducer {
    
    class func handle(action: Action, state: AppState) -> AppState {
        guard let action = action as? GameAction, var gameState = state.gameState else {
            return state
        }
        
        var newState = state
        switch action {
        case .setImages(let images):
            gameState.images = images
        case .setStatus(let status):
            gameState.status = status
        case .setQuestion(let question):
            gameState.question = question
        case .setDidFinishPlaying(let didFinish):
            gameState.didFinishPlaying = didFinish
        }
        
        newState.gameState = gameState
        return newState
    }
    
}
