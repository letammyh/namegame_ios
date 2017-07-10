//
//  ArrayExtensions.swift
//  NameGame
//
//  Created by Tammy Le on 6/27/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

extension Array {
    
    func shuffled() -> Array {
        return self.sorted() {_, _ in arc4random() % 2 == 0}
    }
    
    func randomElements(count: Int) -> Array? {
        guard self.count >= count else {
            return nil
        }
        
        var array = self
        var slice = Array<Element>()
        while slice.count != count {
            slice.append(array.popRandom())
        }
        return slice
    }
    
    mutating func popRandom() -> Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return remove(at: index)
    }
    
    mutating func insertAtRandomIndex(_ newElement: Element) {
        let index = Int(arc4random_uniform(UInt32(count)))
        insert(newElement, at: index)
    }
    
}
