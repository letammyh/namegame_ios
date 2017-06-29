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
    case setScore(Int)
    case setQuestion(Question)
    case setQuestionStatus(Question.Status)
    case setPlayerChoice(UserRecord)
}

final class GameReducer {
    
    class func handle(action: Action, state: AppState) -> AppState {
        guard let action = action as? GameAction, var gameState = state.gameState else {
            return state
        }
        
        var newState = state
        switch action {
        case .setImages(let loadingStatus):
            gameState.images = loadingStatus
        case .setStatus(let status):
            gameState.status = status
        case .setScore(let int):
            gameState.score = int
        case .setQuestion(let question):
            gameState.question = question
        case .setQuestionStatus(let status):
            gameState.question.status = status
        case .setPlayerChoice(let choice):
            gameState.question.playerChoice = choice
        }
        
        newState.gameState = gameState
        return newState
    }
    
}
