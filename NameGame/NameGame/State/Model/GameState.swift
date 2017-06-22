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
        case playing
        case notPlaying
    }
    
    var status: Status
    var score: Int
    var userRecords: [UserRecord]
    var answerQueue: [UserRecord]
    var images: Loading<[UIImage]>
    var question: Question
    
    init(userRecords: [UserRecord], answerQueue: [UserRecord], question: Question) {
        self.status = .notPlaying
        self.score = 0
        self.userRecords = userRecords
        self.answerQueue = answerQueue
        self.images = Loading.notAsked
        self.question = question
    }
    
}
