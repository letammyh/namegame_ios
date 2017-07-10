//
//  MenuWorkflow.swift
//  NameGame
//
//  Created by Tammy Le on 6/23/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

protocol MenuWorkflowPresentationEventObserver: class {
    func presentUserGridCoordinator()
    func presentGameCoordinator()
    func presentAlert(_ alert: UIAlertController)
}

final class MenuWorkflow {
    
    fileprivate let store: Store<AppState>
    private(set) var userRecordService: UserRecordService!
    
    var gamePrepWorkflow: GamePrepWorkflow!
    weak var presentationEventObserver: MenuWorkflowPresentationEventObserver!
    
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
        gamePrepWorkflow.prepareGameState()
    }
    
    func didPressMattModeButton() {
        gamePrepWorkflow.prepareMattGameState()
    }
    
    func didPressTeamMembersButton() {
        presentationEventObserver.presentUserGridCoordinator()
    }
    
}

extension MenuWorkflow: StoreSubscriber {
    
    func newState(state: GameState?) {
        guard let state = state else {
            return
        }
        
        switch state.status {
        case .readyToPlay:
            presentationEventObserver.presentGameCoordinator()
        case .errorLoadingImages:
            presentAlert()
            store.dispatch(AppAction.endGame)
        default:
            break
        }
    }
    
}

fileprivate extension MenuWorkflow {
    
    fileprivate func presentAlert() {
        let title = "Loading error"
        let message = "Couldn't load images for the game."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = "OK"
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        
        presentationEventObserver.presentAlert(alert)
    }
    
}
