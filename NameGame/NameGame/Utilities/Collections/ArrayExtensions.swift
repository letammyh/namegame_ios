//
//  ArrayExtensions.swift
//  NameGame
//
//  Created by Tammy Le on 6/27/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

extension Array {
    
    private mutating func shuffle() {
        for _ in 0..<self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
    
    func shuffled() -> Array {
        var list = self
        list.shuffle()
        return list
    }
    
}
