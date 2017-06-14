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
    
    private(set) var tasks = [URL: URLSessionDataTask]()
    
    deinit {
        for task in tasks.values {
            task.cancel()
        }
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        let imageURL = url.resizedImageURL(maxWidth: 600)
        guard tasks[imageURL] == nil else {
            completion(.failure(ResponseError.alreadyRequested))
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            self?.tasks[imageURL] = nil
            
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
                completion(.failure(ResponseError.emptyResponse))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
        self.tasks[imageURL] = task
    }
    
        
}

fileprivate extension URL {
    
    // Returns a new url using the free image resizing API from RSZ.io.
    // https://rsz.io/
    func resizedImageURL(maxWidth: Int) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        let item = URLQueryItem(name: "width", value: "\(maxWidth)")
        var queryItems = components.queryItems ?? []
        queryItems.append(item)
        components.queryItems = queryItems
        components.host = "rsz.io"
        components.path = "images.contentful.com/" + components.path
        return components.url ?? self
    }
    
}
