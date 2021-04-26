//
//  ReviewTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 08.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photocollectionView: UICollectionView!
    var photo_count: Int!
  
    var items = ["straw.png", "straw2.png"]
    func configure(_ review: Review) {
        userNameLabel.text = review.user
        ratingView.rating = review.rating
        reviewLabel.text = review.text
        dateLabel.text = review.date
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photocollectionView.registerNib(with: ImageCollectionViewCell.self)
        photocollectionView.delegate = self
        photocollectionView.dataSource = self
        photocollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
       
    }
}
extension ReviewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (photo_count == 0){
          return 2
        } else if(photo_count == 1){
          return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(at: indexPath, type: ImageCollectionViewCell.self)
        cell.photoImageView.image = UIImage(named: (self.items[indexPath.item]))
        cell.layer.cornerRadius = 5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "photoTapped"), object: nil)
    }
}

extension ReviewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.item == 0) {
            return CGSize(width: 64, height: collectionView.bounds.height)
        }
        return CGSize(width: 94, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
