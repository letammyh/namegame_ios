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
    
    fileprivate var eventHandler: EndGameViewEventHandler!
    weak var lifecycleObserver: ViewLifecycleObserver? = nil 
    
    class func make() -> EndGameViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleObserver?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleObserver?.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifecycleObserver?.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleObserver?.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycleObserver?.viewDidDisappear(animated)
    }

    func inject(_ eventHandler: EndGameViewEventHandler) {
        self.eventHandler = eventHandler
    }
    
    @IBAction func backToMainMenuButtonPressed(_ sender: Any) {
        eventHandler.didPressBackToMainMenu()
    }

}

extension EndGameViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        guard let gameState = state.gameState else {
            return
        }
        renderFinalScoreText(with: gameState)
    }
    
    func renderFinalScoreText(with gameState: GameState) {
        scoreLabel.text = "You got \(gameState.score) out of \(GamePrepWorkflow.answerQueueSize) correct!"
    }
}
