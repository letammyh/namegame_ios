//
//  UserRecordDecoder.swift
//  NameGame
//
//  Created by Tammy Le on 6/13/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation


final class UserRecordDecoder {
    
    private enum CodingKey: String {
        case items
    }
    

    private static func extractItems(data: Data) throws -> [[String: Any]] {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let response = jsonObject as? [String: Any], let items = response[CodingKey.items.rawValue] as? [[String: Any]] else {
            throw ParsingError.missingKey(CodingKey.items.rawValue)
        }
        
        return items
    }
    
    static func decode(data: Data) throws -> [UserRecord] {
        let items = try extractItems(data: data)
        return items.flatMap { dictionary in
            if let record = try? UserRecord(dictionary: dictionary) {
                return record
            } else {
                return nil
            }
        }
    }
    
}
