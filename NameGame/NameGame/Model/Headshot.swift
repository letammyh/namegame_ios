//
//  Headshot.swift
//  NameGame
//
//  Created by Tammy Le on 6/13/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

struct Headshot {
    
    let type: String
    let mimeType: String
    let id: String
    let url: String
    let alt: String
    let height: Int
    let width: Int
    
    private enum JSONKey: String {
        case type
        case mimeType
        case id
        case url
        case alt
        case height
        case width
    }
    
    init(dictionary: [String:Any]) throws {
        guard let type = dictionary[JSONKey.type.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.type.rawValue)
        }
        
        guard let mimeType = dictionary[JSONKey.mimeType.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.mimeType.rawValue)
        }
        
        guard let id = dictionary[JSONKey.id.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.id.rawValue)
        }
        
        guard let url = dictionary[JSONKey.url.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.url.rawValue)
        }
        
        guard let alt = dictionary[JSONKey.alt.rawValue] as? String else {
            throw ParsingError.missingKey(JSONKey.alt.rawValue)
        }
        
        guard let height = dictionary[JSONKey.height.rawValue] as? Int else {
            throw ParsingError.missingKey(JSONKey.height.rawValue)
        }
        
        guard let width = dictionary[JSONKey.width.rawValue] as? Int else {
            throw ParsingError.missingKey(JSONKey.width.rawValue)
        }
        
        self.type = type
        self.mimeType = mimeType
        self.id = id
        self.url = url
        self.alt = alt
        self.height = height
        self.width = width
    }
    
}

extension Headshot: Equatable {
    
    public static func ==(lhs: Headshot, rhs: Headshot) -> Bool {
        return lhs.id == rhs.id
    }
    
}

