//
//  FilePath.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

final class FilePath {
    
    static var tempDirectory: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    static var imageDirectory: URL {
        return tempDirectory.appendingPathComponent("images")
    }
    
    static func path(for headshot: Headshot) -> URL {
        return imageDirectory.appendingPathComponent("\(headshot.id).jpg")
    }
    
    static func createDirectories() {
        do {
            try FileManager.default.createDirectory(
                at: imageDirectory,
                withIntermediateDirectories: false,
                attributes: nil
            )
        } catch {
            print("\(#function): \(error)")
        }
    }
    
}
