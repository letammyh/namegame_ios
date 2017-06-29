//
//  GameWorkflow.swift
//  NameGame
//
//  Created by Tammy Le on 6/27/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

final class GameWorkflow {
    
    private static let numChoices = 6
    
    fileprivate let store: Store<AppState>
    
    init(store: Store<AppState>) {
        self.store = store
    }

    func generateNewQuestion() -> Question? {
        guard let gameState = store.state.gameState else {
            return nil
        }
        let userRecords = gameState.userRecords.shuffled()
        var answerQueue = gameState.answerQueue
        
        guard let correctChoice = answerQueue.popLast() else {
            return nil
        }
        
        var choices = Array(userRecords.prefix(GameWorkflow.numChoices - 1))
        choices.append(correctChoice)
        choices = choices.shuffled()
        
        return Question(choices: choices, correctChoice: correctChoice)
    }
    
}

extension GameWorkflow: GameViewEventHandler {
    
    func didGetUserChoice(_ choice: UserRecord) {
        store.dispatch(GameAction.setPlayerChoice(choice))
        
        guard let gameState = store.state.gameState, let playerChoice = gameState.question.playerChoice else {
            return
        }
        
        if playerChoice == store.state.gameState?.question.correctChoice {
            store.dispatch(GameAction.setScore(gameState.score + 1))
            store.dispatch(GameAction.setQuestionStatus(.correctlyAnswered))
        } else {
            store.dispatch(GameAction.setQuestionStatus(.incorrectlyAnswered))
        }
    }
    
    func didGetNewQuestion() {
        guard let newQuestion = generateNewQuestion() else {
            didEndGame()
            return
        }
        
        store.dispatch(GameAction.setQuestion(newQuestion))
    }
    
    func didEndGame() {
        store.dispatch(AppAction.endGame)
        // presentation event observer -- implement
    }
}
