//
//  UserRecord.swift
//  NameGame
//
//  Created by Tammy Le on 6/12/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

struct UserRecord {
    
    let id: String
    let firstName: String
    let lastName: String
    let headshot: Headshot
    
    private enum JSONKey: String {
        case id
        case firstName
        case lastName
        case headshot
    }
    
    init(dictionary: [String: Any]) throws {
        guard let id = dictionary[JSONKey.id.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.id.rawValue)
        }
        
        guard let firstName = dictionary[JSONKey.firstName.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.firstName.rawValue)
        }
        
        guard let lastName = dictionary[JSONKey.lastName.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.lastName.rawValue)
        }
        
        guard let headshotDictionary = dictionary[JSONKey.headshot.rawValue] as? [String:Any] else {
            throw ParsingError.missingKey(JSONKey.headshot.rawValue)
        }
        
        let headshot = try Headshot(dictionary: headshotDictionary)
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.headshot = headshot
    }
    
}

extension UserRecord: Equatable {
    
    public static func ==(lhs: UserRecord, rhs: UserRecord) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension UserRecord: Comparable {
    
    public static func <(lhs: UserRecord, rhs: UserRecord) -> Bool {
        guard lhs.lastName != rhs.lastName else {
            return lhs.firstName < rhs.firstName
        }
        return lhs.lastName < rhs.lastName
    }
    
}
