//
//  RootCollectionViewController.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserRecordCell"

class RootCollectionViewController: UICollectionViewController, ImageCacheEventObserver {
    
    var userRecords = [UserRecord]()
    
    let imageCache = ImageCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCache.eventObserver = self


        // Do any additional setup after loading the view.
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
    
    // ImageCacheEventObserver Protocol
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userRecords.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UserRecordCell.dequeueCell(in: collectionView, with: reuseIdentifier, for: indexPath)
    
        // Configure the cell
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
    
    private func reloadVisibleCells() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    private func reload(_ userRecords: [UserRecord]) {
        self.userRecords = userRecords.sorted()
        collectionView?.reloadData()
    }

}
