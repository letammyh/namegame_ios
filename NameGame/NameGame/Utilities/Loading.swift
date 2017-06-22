//
//  Loading.swift
//  NameGame
//
//  Created by Tammy Le on 6/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

enum Loading<T> {
    case notAsked
    case loading
    case loaded(T)
    case error(Error)
}
