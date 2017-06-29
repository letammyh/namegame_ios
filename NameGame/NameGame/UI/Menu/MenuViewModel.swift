//
//  MenuViewModel.swift
//  NameGame
//
//  Created by Tammy Le on 6/29/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

struct MenuViewModel {
    
    let shouldShowActivityIndicator: Bool
    
    init() {
        shouldShowActivityIndicator = false
    }
    
    init(_ state: AppState) {
        guard let gameState = state.gameState else {
            shouldShowActivityIndicator = false
            return
        }
        
        switch gameState.status {
        case .preparing:
            shouldShowActivityIndicator = true
        default:
            shouldShowActivityIndicator = false
        }
    }
    
}

extension MenuViewModel: Equatable {
    
    public static func ==(lhs: MenuViewModel, rhs: MenuViewModel) -> Bool {
        return lhs.shouldShowActivityIndicator == rhs.shouldShowActivityIndicator
    }
    
}


