//
//  EndGameWorkflow.swift
//  NameGame
//
//  Created by Tammy Le on 7/5/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift

protocol EndGameWorkflowPresentationEventObserver: class {
    func presentMainMenu()
    func presentNewGame()
}

final class EndGameWorkflow {
    
    fileprivate let store: Store<AppState>
    
    weak var presentationEventObserver: EndGameWorkflowPresentationEventObserver!
    
    init(store: Store<AppState>) {
        self.store = store
    }
    
}

extension EndGameWorkflow: EndGameViewEventHandler {
    
    func didPressBackToMainMenu() {
        presentationEventObserver.presentMainMenu()
    }
    
}
