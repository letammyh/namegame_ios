//
//  GameState.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

struct GameState {
    
    enum Status {
        case preparing
        case readyToPlay
        case playing
        case finishedPlaying
        case errorLoadingImages
    }
    
    var status: Status
    var score: Int
    var userRecords: [UserRecord]
    var answerQueue: [UserRecord]
    var images: [UserRecord: UIImage] {
        didSet {
            if self.userRecords.count == self.images.values.count {
                self.status = .readyToPlay
            } else {
                self.status = .preparing
            }
        }
    }
    var question: Question
    var didFinishPlaying: Bool
    
    init(userRecords: [UserRecord], answerQueue: [UserRecord], question: Question) {
        self.status = .preparing
        self.score = 0
        self.userRecords = userRecords
        self.answerQueue = answerQueue
        self.images = [:]
        self.question = question
        self.didFinishPlaying = false
    }
    
}
