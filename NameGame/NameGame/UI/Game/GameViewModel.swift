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
    
    let choices: [UserRecord]
    let correctChoice: UserRecord
    let correctChoiceIndex: Int
    var correctChoiceNameComponents: PersonNameComponents
    let imageDictionary: [UserRecord: UIImage]
    let questionAnsweredCorrectly: Bool?
    let score: Int
    let finishedPlaying: Bool
    
    init?(_ state: AppState) {
        guard let gameState = state.gameState,
            case .playing = gameState.status else {
            return nil
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
        correctChoiceIndex = choices.index(of: correctChoice) ?? 0
        
        correctChoiceNameComponents = PersonNameComponents()
        correctChoiceNameComponents.givenName = correctChoice.firstName
        correctChoiceNameComponents.familyName = correctChoice.lastName
        
        imageDictionary = gameState.images
        score = gameState.score

        finishedPlaying = gameState.didFinishPlaying
    }
    
}

extension GameViewModel: Equatable {
    
    public static func ==(lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        guard let leftIsCorrect = lhs.questionAnsweredCorrectly,
            let rightIsCorrect = rhs.questionAnsweredCorrectly else {
            return false
        }
        
        if lhs.choices == rhs.choices,
            lhs.correctChoice == rhs.correctChoice,
            lhs.correctChoiceNameComponents == rhs.correctChoiceNameComponents,
            leftIsCorrect == rightIsCorrect,
            lhs.score == rhs.score,
            lhs.finishedPlaying == rhs.finishedPlaying {
            return true
        }
        
        return false
    }
    
}
