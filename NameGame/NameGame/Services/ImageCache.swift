//
//  ImageCache.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCacheEventObserver: class {
    func didCache(image: UIImage, for userRecord: UserRecord)
    func failedToCacheImage(for userRecord: UserRecord)
}

class ImageCache {
    
    private let imageService = ImageService()
    weak var eventObserver: ImageCacheEventObserver? = nil
    
    func image(for userRecord: UserRecord) -> UIImage? {
        let filePath = FilePath.path(for: userRecord.headshot)
        guard let cachedImage = UIImage(named: filePath.relativePath) else {
            fetchImage(for: userRecord)
            return nil
        }
        
        return cachedImage
    }
    
    private func fetchImage(for userRecord: UserRecord) {
        imageService.fetchImage(url: userRecord.headshot.url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.cacheImage(image, for: userRecord)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func cacheImage(_ image: UIImage, for userRecord: UserRecord) {
        let filePath = FilePath.path(for: userRecord.headshot)
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            return
        }
        
        do {
            try imageData.write(to: filePath)
            DispatchQueue.main.async { [weak self] in
                self?.eventObserver?.didCache(image: image, for: userRecord)
            }
        } catch {
            self.eventObserver?.failedToCacheImage(for:userRecord)
        }
    }
    
}
