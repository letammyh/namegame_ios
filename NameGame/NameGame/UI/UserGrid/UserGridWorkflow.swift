//
//  UserGridWorkflow.swift
//  NameGame
//
//  Created by Tammy Le on 7/5/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift

protocol UserGridWorkflowPresentationEventObserver: class {
    func returnToMainMenu()
}

final class UserGridWorkflow {
    
    weak var presentationEventObserver: UserGridWorkflowPresentationEventObserver!
    
}

extension UserGridWorkflow: UserGridViewEventHandler {
    
    func didPressMainMenuButton() {
        presentationEventObserver.returnToMainMenu()
    }
}
