//
//  ImageService.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

final class ImageService {
    
    let sharedCache = NSCache<NSString, UIImage>()
    
    private(set) var task: URLSessionDataTask? = nil
    
    
    func fetchImage(userRecord: UserRecord, completion: @escaping (Result<UIImage>) -> Void) {
        if let cacheImage = sharedCache.object(forKey: userRecord.headshot.url as NSString) {
            completion(.success(cacheImage))
            return
        }
        
        let url = URL(string: userRecord.headshot.url)!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.task = nil
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode)  else {
                completion(.failure(ResponseError.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(ResponseError.emptyResponse))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(ResponseError.emptyImage))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
        self.task = task 
    }
    
        
}
