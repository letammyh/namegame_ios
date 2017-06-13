//
//  Headshot.swift
//  NameGame
//
//  Created by Tammy Le on 6/13/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

struct Headshot {
    
    private enum CodingKey: String {
        case type
        case mimeType
        case id
        case url
        case alt
        case height
        case width
    }
    
    let type: String
    let mimeType: String
    let id: String
    let url: String
    let alt: String
    let height: Int
    let width: Int
    
    
    init(dictionary: [String:Any]) throws {
        guard let type = dictionary[CodingKey.type.rawValue] as? String else {
            throw ParsingError.missingKey(CodingKey.type.rawValue)
        }
        
        guard let mimeType = dictionary[CodingKey.mimeType.rawValue] as? String else {
            throw ParsingError.missingKey(CodingKey.mimeType.rawValue)
        }
        
        guard let id = dictionary[CodingKey.id.rawValue] as? String else {
            throw ParsingError.missingKey(CodingKey.id.rawValue)
        }
        
        guard let url = dictionary[CodingKey.url.rawValue] as? String else {
            throw ParsingError.missingKey(CodingKey.url.rawValue)
        }
        
        guard let alt = dictionary[CodingKey.alt.rawValue] as? String else {
            throw ParsingError.missingKey(CodingKey.alt.rawValue)
        }
        
        guard let height = dictionary[CodingKey.height.rawValue] as? Int else {
            throw ParsingError.missingKey(CodingKey.height.rawValue)
        }
        
        guard let width = dictionary[CodingKey.width.rawValue] as? Int else {
            throw ParsingError.missingKey(CodingKey.width.rawValue)
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

