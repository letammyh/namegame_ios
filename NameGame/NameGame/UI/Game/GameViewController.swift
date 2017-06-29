//
//  GameViewController.swift
//  NameGame
//
//  Created by Tammy Le on 6/27/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

protocol GameViewEventHandler {
    func didGetUserChoice(_ choice: UserRecord)
    func didGetNewQuestion()
    func didEndGame()
}

class GameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var userButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    fileprivate var imageDictionary: [UserRecord: UIImage]!
    
    fileprivate var viewModel = GameViewModel()
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    private var eventHandler: GameViewEventHandler!
    
    class func make() -> GameViewController {
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
    
    @IBAction func userButtonPressed(_ sender: UIButton) {
        guard let selectedImage = sender.backgroundImage(for: .normal) else {
            return
        }
        guard let selectedUser = imageDictionary.key(for: selectedImage) else {
            return
        }
        eventHandler.didGetUserChoice(selectedUser)
        
        // Wait a few seconds before displaying new question
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.eventHandler.didGetNewQuestion()
        })
    }
    
    func inject(_ eventHandler: GameViewEventHandler) {
        self.eventHandler = eventHandler
    }
    
    func inject(_ imageDictionary: [UserRecord:UIImage]) {
        self.imageDictionary = imageDictionary
    }

}

extension GameViewController: StoreSubscriber {
    
    func newState(state: GameViewModel) {
        viewModel = state
        renderChoices(with: viewModel)
        renderCorrectChoice(with: viewModel)
        renderScore(with: viewModel)
    }
    
    func renderChoices(with viewModel: GameViewModel) {
        guard let choices = viewModel.choices else {
            return
        }
        
        for (index, choice) in choices.enumerated() {
            let image = imageDictionary[choice]
            userButtons[index].setImage(image, for: .normal)
        }
        
        guard let correctChoice = viewModel.correctChoice else {
            return
        }
        nameLabel.text = correctChoice.firstName + " " + correctChoice.lastName
        nameLabel.textColor = UIColor.white
    }
    
    func renderCorrectChoice(with viewModel: GameViewModel) {
        guard let isCorrect = viewModel.questionAnsweredCorrectly else {
            return
        }
        if isCorrect {
            nameLabel.textColor = UIColor.green
        } else {
            nameLabel.textColor = UIColor.red
        }
    }
    
    func renderScore(with viewModel: GameViewModel) {
        scoreLabel.text = "Score: \(viewModel.score)"
    }
    
}
