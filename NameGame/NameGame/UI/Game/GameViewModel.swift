//
//  GameViewModel.swift
//  NameGame
//
//  Created by Tammy Le on 6/27/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

struct GameViewModel {
    
    let choices: [UserRecord]?
    let correctChoice: UserRecord?
    let questionAnsweredCorrectly: Bool?
    let score: Int
    
    init() {
        choices = nil
        correctChoice = nil
        questionAnsweredCorrectly = nil
        score = 0
    }
    
    init(_ state: AppState) {
        guard let gameState = state.gameState else {
            choices = nil
            correctChoice = nil
            questionAnsweredCorrectly = nil
            score = 0
            return
        }
        
        switch gameState.question.status {
        case .correctlyAnswered:
            questionAnsweredCorrectly = true
        case .incorrectlyAnswered:
            questionAnsweredCorrectly = false
        case .unanswered:
            questionAnsweredCorrectly = nil
        }
        
        choices = gameState.question.choices
        correctChoice = gameState.question.correctChoice
        score = gameState.score
    }
    
}

extension GameViewModel: Equatable {
    
    public static func ==(lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        guard let leftChoices = lhs.choices,
            let rightChoices = rhs.choices,
            leftChoices == rightChoices else {
                return false
        }
        
        guard let leftCorrectChoice = lhs.correctChoice,
            let rightCorrectChoice = rhs.correctChoice,
            leftCorrectChoice == rightCorrectChoice else {
                return false
        }
        
        guard lhs.questionAnsweredCorrectly == rhs.questionAnsweredCorrectly else {
            return false
        }
        
        guard lhs.score == rhs.score else {
            return false
        }
        
        return true
    }
    
}
