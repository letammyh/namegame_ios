//
//  UserGridViewController.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

final class UserGridViewController: UICollectionViewController {
    
    static let reuseIdentifier = "userRecordCell"
    
    fileprivate(set) var userRecords = [UserRecord]()
    private let imageCache = ImageCache()
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    
    class func make() -> UserGridViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCache.eventObserver = self
        
        UserRecordService.shared.fetchUserRecords { [weak self] result in
            switch result {
            case .success(let userRecords):
                DispatchQueue.main.async {
                    self?.reload(userRecords)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userRecords.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UserRecordCell.dequeueCell(in: collectionView, with: UserGridViewController.reuseIdentifier, for: indexPath)
    
        let cachedImage = imageCache.image(for: userRecords[indexPath.item])
        cell.imageView.image = cachedImage
    
        return cell
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        reloadVisibleCells()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadVisibleCells()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            reloadVisibleCells()
        }
    }

}

extension UserGridViewController: ImageCacheEventObserver {
    
    func didCache(image: UIImage, for userRecord: UserRecord) {
        guard let collectionView = self.collectionView else {
            return
        }
        
        if let index = userRecords.index(of: userRecord) {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = UserRecordCell.cell(in: collectionView, at: indexPath)
            cell?.imageView.image = image
        }
    }
}

fileprivate extension UserGridViewController {
    
    func reload(_ userRecords: [UserRecord]) {
        self.userRecords = userRecords.sorted()
        collectionView?.reloadData()
    }
    
    func reloadVisibleCells() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
}
