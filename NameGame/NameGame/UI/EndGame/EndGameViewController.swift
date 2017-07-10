//
//  EndGameViewController.swift
//  NameGame
//
//  Created by Tammy Le on 7/5/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

protocol EndGameViewEventHandler {
    func didPressBackToMainMenu()
}

class EndGameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    private var finalScore: Int!
    
    fileprivate var eventHandler: EndGameViewEventHandler!
    
    class func make() -> EndGameViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "You got \(finalScore!) out of \(GamePrepWorkflow.answerQueueSize) correct!"
    }

    func inject(_ eventHandler: EndGameViewEventHandler) {
        self.eventHandler = eventHandler
    }
    
    func inject(_ finalScore: Int) {
        self.finalScore = finalScore
    }
    
    @IBAction func backToMainMenuButtonPressed(_ sender: Any) {
        eventHandler.didPressBackToMainMenu()
    }

}
