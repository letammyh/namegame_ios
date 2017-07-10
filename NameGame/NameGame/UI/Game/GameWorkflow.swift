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

protocol GameWorkflowPresentationEventObserver: class {
    func returnToMainMenu()
    func presentEndGameCoordinator()
}

final class GameWorkflow {
    
    private static let numChoices = 6
    
    fileprivate let store: Store<AppState>
    weak var presentationEventObserver: GameWorkflowPresentationEventObserver!
    
    init(store: Store<AppState>) {
        self.store = store
    }

    func generateNextQuestion() {
        guard var newState = store.state.gameState else {
            return
        }
        
        guard let correctChoice = newState.answerQueue.popLast(),
            let correctChoiceIndex = newState.userRecords.index(of: correctChoice) else {
                newState.didFinishPlaying = true
                store.dispatch(AppAction.setGameState(newState))
                return
        }

        var userRecords = newState.userRecords
        userRecords.remove(at: correctChoiceIndex)
        if var choices = userRecords.randomElements(count: GameWorkflow.numChoices - 1) {
            choices.insertAtRandomIndex(correctChoice)
            let question = Question(choices: choices, correctChoice: correctChoice)
            newState.question = question
            store.dispatch(AppAction.setGameState(newState))
        }
    }
    
}

extension GameWorkflow: GameViewEventHandler {
    
    func didGetUserChoice(_ playerChoice: UserRecord) {
        guard var gameState = store.state.gameState else {
            return
        }

        if playerChoice == gameState.question.correctChoice {
            gameState.question.status = .correctlyAnswered
            gameState.score += 1
        } else {
            gameState.question.status = .incorrectlyAnswered
        }
        
        store.dispatch(AppAction.setGameState(gameState))
    }
    
    func didShowResult() {
        generateNextQuestion()
    }
    
    func didShowScore() {
        guard let gameState = store.state.gameState else {
            return
        }
        
        if gameState.answerQueue.count == 0, gameState.status == .finishedPlaying {
            store.dispatch(GameAction.setDidFinishPlaying(true))
        }
    }
    
    func didPressEndGame() {
        store.dispatch(AppAction.endGame)
        presentationEventObserver.returnToMainMenu()
    }
    
    func didFinishGame() {
        presentationEventObserver.presentEndGameCoordinator()
    }
}
