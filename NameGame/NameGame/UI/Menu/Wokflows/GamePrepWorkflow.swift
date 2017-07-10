//
//  GamePrepWorkflow.swift
//  NameGame
//
//  Created by Tammy Le on 6/28/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

final class GamePrepWorkflow {
    
    public static var answerQueueSize = 6
    private static let numChoices = 6
    
    fileprivate let store: Store<AppState>
    private var imageCache: ImageCache!
    
    init(store: Store<AppState>) {
        self.store = store
    }
    
    func inject(_ imageCache: ImageCache) {
        self.imageCache = imageCache
        imageCache.eventObserver = self
    }
    
    // Regular mode
    func prepareGameState() {
        guard case .loaded(let userRecords) = store.state.userRecords,
            let gameUserRecords = userRecords.randomElements(count: GamePrepWorkflow.answerQueueSize),
            let gameState = generateInitialGameState(with: gameUserRecords) else {
                return
        }
        
        imageCache.eventObserver = self
        
        store.dispatch(AppAction.setGameState(gameState))
        loadGameStateImages(with: gameUserRecords)
    }
    
    // Matt mode
    func prepareMattGameState() {
        guard case .loaded(let userRecords) = store.state.userRecords else {
                return
        }
        
        let mattUserRecords = userRecords.filter { $0.firstName.contains("Mat") }
        GamePrepWorkflow.answerQueueSize = mattUserRecords.count
        
        guard let gameState = generateInitialGameState(with: mattUserRecords) else {
            return
        }
        
        imageCache.eventObserver = self
        
        store.dispatch(AppAction.setGameState(gameState))
        loadGameStateImages(with: mattUserRecords)
    }
    
    private func generateInitialGameState(with gameUserRecords: [UserRecord]) -> GameState? {
        var answerQueue = gameUserRecords
        var userRecords = gameUserRecords
        
        guard let correctChoice = answerQueue.popLast(),
            let correctChoiceIndex = userRecords.index(of: correctChoice) else {
            return nil
        }
        
        userRecords.remove(at: correctChoiceIndex)
        guard var choices = userRecords.randomElements(count: GamePrepWorkflow.numChoices - 1) else {
            return nil
        }
        choices.insertAtRandomIndex(correctChoice)
        
        let question = Question(choices: choices, correctChoice: correctChoice)
        return GameState(userRecords: gameUserRecords, answerQueue: answerQueue, question: question)
    }
    
    private func loadGameStateImages(with userRecords: [UserRecord]) {
        guard var images = store.state.gameState?.images else {
            return
        }
        
        for userRecord in userRecords {
            images[userRecord] = imageCache.image(for: userRecord)
        }
        
        store.dispatch(GameAction.setImages(images))
    }
    
}

extension GamePrepWorkflow: ImageCacheEventObserver {
    
    func didCache(image: UIImage, for userRecord: UserRecord) {
        guard var images = store.state.gameState?.images else {
            return
        }
        
        images[userRecord] = image
        store.dispatch(GameAction.setImages(images))
    }
    
    func failedToCacheImage(for userRecord: UserRecord) {
        store.dispatch(GameAction.setStatus(.errorLoadingImages))
    }
    
}
