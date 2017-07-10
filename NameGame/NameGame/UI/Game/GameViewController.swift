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
    func didShowResult()
    func didShowScore()
    func didPressEndGame()
    func didFinishGame()
}

class GameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var userButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    fileprivate var imageDictionary: [UserRecord: UIImage]!
    
    fileprivate var viewModel: GameViewModel?
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    fileprivate var eventHandler: GameViewEventHandler!
    
    fileprivate var currentCorrectChoiceIndex = 0
    fileprivate var currentSelectedChoiceIndex = 0
    
    fileprivate let green = UIColor(red: 74.0/255.0, green: 226.0/255.0, blue: 59.0/255.0, alpha: 1)
    fileprivate let red = UIColor(red: 228.0/255.0, green: 67.0/255.0, blue: 52.0/255.0, alpha: 1)
    
    class func make() -> GameViewController {
        return UIStoryboard.main.make()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleObserver?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
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
        guard let viewModel = self.viewModel else {
            return
        }
        
        let index = sender.tag
        if index >= 0, index < viewModel.choices.count {
            currentSelectedChoiceIndex = index
            
            let selectedUser = viewModel.choices[index]
            eventHandler.didGetUserChoice(selectedUser)
        }
    }
    
    @IBAction func endGameButtonPressed(_ sender: Any) {
        eventHandler.didPressEndGame()
    }
    
    func inject(_ eventHandler: GameViewEventHandler) {
        self.eventHandler = eventHandler
    }

}

extension GameViewController: StoreSubscriber {
    
    func newState(state: GameViewModel?) {
        viewModel = state
        guard let gameViewModel = viewModel else {
            return
        }
        
        renderImageDictionary(with: gameViewModel)
        renderChoices(with: gameViewModel)
        renderResult(with: gameViewModel)
        renderScore(with: gameViewModel)
        renderEndGame(with: gameViewModel)
    }
    
    func renderImageDictionary(with viewModel: GameViewModel) {
        self.imageDictionary = viewModel.imageDictionary
    }
    
    func renderChoices(with viewModel: GameViewModel) {
        userButtons[currentSelectedChoiceIndex].layer.borderWidth = 0.0
        userButtons[currentCorrectChoiceIndex].layer.borderWidth = 0.0
        
        for (index, choice) in viewModel.choices.enumerated() {
            let image = imageDictionary[choice]
            
            let button = userButtons[index]
            button.setImage(image, for: .normal)
            button.tag = index
            
            if choice == viewModel.correctChoice {
                currentCorrectChoiceIndex = index
            }
        }
        
        nameLabel.text = viewModel.correctChoice.firstName + " " + viewModel.correctChoice.lastName
        nameLabel.textColor = UIColor(red: 51.0/255.0, green: 138.0/255.0, blue: 151.0/255.0, alpha: 1)
    }
    
    func renderResult(with viewModel: GameViewModel) {
        guard let isCorrect = viewModel.questionAnsweredCorrectly else {
            return
        }
        
        userButtons[currentCorrectChoiceIndex].layer.borderWidth = 3.0
        userButtons[currentCorrectChoiceIndex].layer.borderColor = green.cgColor
        
        if isCorrect {
            nameLabel.textColor = green
        } else {
            userButtons[currentSelectedChoiceIndex].layer.borderColor = red.cgColor
            userButtons[currentSelectedChoiceIndex].layer.borderWidth = 3.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.eventHandler.didShowResult()
        })
        
    }
    
    func renderScore(with viewModel: GameViewModel) {
        scoreLabel.text = "Score: \(viewModel.score)"
        
        eventHandler.didShowScore()
    }
    
    func renderEndGame(with viewModel: GameViewModel) {
        if viewModel.finishedPlaying {
            self.eventHandler.didFinishGame()
        }
    }
    
}
