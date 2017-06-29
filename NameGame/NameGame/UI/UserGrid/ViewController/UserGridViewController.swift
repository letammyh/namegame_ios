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
    
    private static let reuseCellIdentifier = "userRecordCell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var imageCache: ImageCache!
    
    fileprivate var viewModel = UserGridViewModel()
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    
    class func make() -> UserGridViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).sectionFootersPinToVisibleBounds = true
        
        imageCache.eventObserver = self
        
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard viewModel.userRecords != nil else {
            return 0
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userRecords = viewModel.userRecords else {
            return 0
        }
        return userRecords.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userRecords = viewModel.userRecords ?? []
        let cachedImage = imageCache.image(for: userRecords[indexPath.item])
        
        let cell = UserRecordCell.dequeueCell(in: collectionView, with: UserGridViewController.reuseCellIdentifier, for: indexPath)
        cell.imageView.image = cachedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "mainMenuFooter", for: indexPath)
        footerView.backgroundColor?.withAlphaComponent(0.5)
        return footerView
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

extension UserGridViewController {
    
    fileprivate func reloadVisibleCells() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func inject(_ imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
}

extension UserGridViewController: ImageCacheEventObserver {
    func failedToCache(_ userRecord: UserRecord) {
        return
    }

    func didCache(image: UIImage, for userRecord: UserRecord) {
        guard let collectionView = self.collectionView,
            let userRecords = viewModel.userRecords else {
            return
        }
        
        if let index = userRecords.index(of: userRecord) {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = UserRecordCell.cell(in: collectionView, at: indexPath)
            cell?.imageView.image = image
        }
    }
}

extension UserGridViewController: StoreSubscriber {
    
    func newState(state: UserGridViewModel) {
        viewModel = state
        renderLoadingStatus(with: viewModel)
        renderUserRecords(with: viewModel)
        presentAlert(with: viewModel)
    }
    
    func renderLoadingStatus(with viewModel: UserGridViewModel) {
        if viewModel.shouldShowActivityIndicator {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func renderUserRecords( with viewModel: UserGridViewModel) {
        collectionView?.reloadData()
    }
    
    func presentAlert(with viewModel: UserGridViewModel) {
        guard let errorMessage = viewModel.errorMessage else {
            return
        }
        
        let title = "Loading error"
        let message = errorMessage
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = "OK"
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
