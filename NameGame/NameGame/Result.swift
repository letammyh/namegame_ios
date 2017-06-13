//
//  Result.swift
//  NameGame
//
//  Created by Tammy Le on 6/13/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}
