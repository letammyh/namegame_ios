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
    
    private static let answerQueueSize = 20
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
    
    func prepareGameState() {
        guard case .loaded(let userRecords) = store.state.userRecords else {
            return
        }
        imageCache.eventObserver = self
        
        let gameUserRecords = Array(userRecords.shuffled().prefix(upTo: GamePrepWorkflow.answerQueueSize))
        guard let gameState = generateInitialGameState(with: gameUserRecords) else {
            return
        }
        store.dispatch(AppAction.setGameState(gameState))
        
        loadGameStateImages(with: gameUserRecords)
    }
    
    private func generateInitialGameState(with gameUserRecords: [UserRecord]) -> GameState? {
        var answerQueue = gameUserRecords
        
        guard let correctChoice = answerQueue.popLast() else {
            return nil
        }
        var choices = Array(gameUserRecords.prefix(GamePrepWorkflow.numChoices - 1))
        choices.append(correctChoice)
        choices = choices.shuffled()
        
        let question = Question(choices: choices, correctChoice: correctChoice)
        return GameState(userRecords: gameUserRecords, answerQueue: answerQueue, question: question)
    }
    
    private func loadGameStateImages(with userRecords: [UserRecord]) {
        guard
            var images = store.state.gameState?.images else
        {
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
    
    func failedToCache(_ userRecord: UserRecord) {
        store.dispatch(GameAction.setStatus(.errorLoadingImages))
    }
    
}
