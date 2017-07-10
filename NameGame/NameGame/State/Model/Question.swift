//
//  Question.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

struct Question {
    
    enum Status {
        case unanswered
        case correctlyAnswered
        case incorrectlyAnswered
    }
    
    var choices: [UserRecord]
    var correctChoice: UserRecord
    var status: Status

    init(choices: [UserRecord], correctChoice: UserRecord) {
        self.choices = choices
        self.correctChoice = correctChoice
        self.status = .unanswered
    }
    
}
