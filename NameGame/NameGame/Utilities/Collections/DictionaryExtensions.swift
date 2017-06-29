//
//  DictionaryExtensions.swift
//  NameGame
//
//  Created by Tammy Le on 6/28/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    
    func key(for value: Value) -> Key? {
        for key in self.keys {
            if self[key] == value {
                return key
            }
        }
        return nil
    }
    
}
