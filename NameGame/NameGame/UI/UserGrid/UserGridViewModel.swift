//
//  UserGridViewModel.swift
//  NameGame
//
//  Created by Tammy Le on 6/26/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

struct UserGridViewModel {
    
    let userRecords: [UserRecord]?
    let shouldShowActivityIndicator: Bool
    let errorMessage: String?
    
    
    init() {
        userRecords = nil
        shouldShowActivityIndicator = false
        errorMessage = nil
    }
    
    init(_ state: AppState) {
        switch state.userRecords {
        case .notAsked:
            userRecords = nil
            shouldShowActivityIndicator = false
            errorMessage = nil
        case .loading:
            userRecords = nil
            shouldShowActivityIndicator = true
            errorMessage = nil
        case .loaded(let records):
            userRecords = records
            shouldShowActivityIndicator = false
            errorMessage = nil
        case .error:
            userRecords = nil
            shouldShowActivityIndicator = false
            errorMessage = "Unable to load user records."
        }
    }
    
}

extension UserGridViewModel: Equatable {
    
    public static func ==(lhs: UserGridViewModel, rhs: UserGridViewModel) -> Bool {
        guard let leftUserRecords = lhs.userRecords,
            let rightUserRecords = rhs.userRecords,
            leftUserRecords == rightUserRecords else {
                return false
        }
        
        guard lhs.shouldShowActivityIndicator == rhs.shouldShowActivityIndicator else {
            return false
        }
        
        guard let leftErrorMessage = lhs.errorMessage,
            let rightErrorMessage = rhs.errorMessage,
            leftErrorMessage == rightErrorMessage else {
                return false
        }
        
        return true
    }
}
