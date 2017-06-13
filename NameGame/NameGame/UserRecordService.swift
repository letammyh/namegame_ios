//
//  UserRecordService.swift
//  NameGame
//
//  Created by Tammy Le on 6/13/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

final class UserRecordService {
    
    private struct Endpoint {
        static let userRecords = URL(string: "https://willowtreeapps.com/api/v1.0/profiles/")!
    }
    
    enum ResponseError: Error {
        case emptyResponse
        case serverError
    }
    
    static let shared = UserRecordService()
    
    private(set) var task: URLSessionDataTask? = nil
    
    
    // Load data from JSON file into a list of UserRecord objects.
    func fetchUserRecords(completion: @escaping (Result<[UserRecord]>) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoint.userRecords) { [weak self] data, response, error in
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
            
            do {
                let records = try UserRecordDecoder.decode(data: data)
                completion(.success(records))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        self.task = task
    }
}
