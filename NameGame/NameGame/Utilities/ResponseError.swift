//
//  ResponseError.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case emptyResponse
    case serverError
    case emptyImage
}
