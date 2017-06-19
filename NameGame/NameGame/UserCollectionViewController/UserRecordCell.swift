//
//  UserRecordCell.swift
//  NameGame
//
//  Created by Tammy Le on 6/14/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit

final class UserRecordCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static func dequeueCell(in collectionView: UICollectionView, with identifier: String, for indexPath: IndexPath) -> UserRecordCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! UserRecordCell
    }
    
    static func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UserRecordCell? {
        return collectionView.cellForItem(at: indexPath) as? UserRecordCell
    }
}
