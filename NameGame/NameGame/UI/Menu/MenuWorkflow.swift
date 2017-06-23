//
//  MenuWorkflow.swift
//  NameGame
//
//  Created by Tammy Le on 6/23/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift

protocol CoordinatorHandler {
    
    func createUserGridCoordinator()
    func createGameCoordinator()
}

final class MenuWorkflow {
    
    let store: Store<AppState>
    private(set) var userRecordService: UserRecordService!
    var coordinatorHandler: CoordinatorHandler!
    
    init(store: Store<AppState>) {
        self.store = store
        store.dispatch(AppAction.setUserRecords(.notAsked))
    }
    
    func inject(_ userRecordService: UserRecordService) {
        self.userRecordService = userRecordService
    }
    
    func refreshUserRecords() {
        store.dispatch(AppAction.setUserRecords(.loading))
        
        userRecordService.fetchUserRecords { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userRecords):
                    self.store.dispatch(AppAction.setUserRecords(.loaded(userRecords)))
                case .failure(let error):
                    self.store.dispatch(AppAction.setUserRecords(.error(error)))
                }
            }
        }
    }
    
}

extension MenuWorkflow: MenuViewEventHandler {
    
    func didPressPlayButton() {
        // TODO
        coordinatorHandler.createGameCoordinator()
    }
    
    func didPressTeamMembersButton() {
        coordinatorHandler.createUserGridCoordinator()
    }
    
}
