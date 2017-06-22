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
    case setImages(Loading<[UIImage]>)
    case setStatus(GameState.Status)
    case playerAnswersCorrectly
    case goToNextQuestion(Question)
    case gameTerminated
}

final class GameReducer {
    
    class func handle(action: Action, state: AppState) -> AppState {
        guard let action = action as? GameAction else {
            return state
        }
        
        var state = state
        switch action {
        case .setImages(let loadingStatus):
            state.gameState?.images = loadingStatus
        case .setStatus(let status):
            state.gameState?.status = status
        case .playerAnswersCorrectly:
            state.gameState?.score += 1
        case .goToNextQuestion(let question):
            state.gameState?.question = question
        case .gameTerminated:
            state.gameState = nil
        }
        
        return state
    }
}
