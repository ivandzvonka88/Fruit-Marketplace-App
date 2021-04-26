//
//  FruitTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import FirebaseUI

class ShopCollectionViewCell: UICollectionViewCell, ReusableItem {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var fruitId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerNib(with: ImageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func configure(with fruit: FruitViewModel) {
        nameLabel.text = fruit.name
        logoImageView.image = fruit.getImage()
        ratingLabel.text = String(format: "%.1f", fruit.rating)
        ratingsLabel.text = "(\(fruit.ratings))"
        collectionView.setContentOffset(CGPoint(x: -collectionView.contentInset.left, y: 0), animated: false)
        dateLabel.text = fruit.date

        if fruit.reviews == 0 {
            reviewsLabel.text = "No reviews"
        } else if fruit.reviews == 1 {
            reviewsLabel.text = "1 review"
        } else {
            reviewsLabel.text = "\(fruit.reviews) reviews"
        }
        
        likeButton.isSelected = UserManager.likedFruits.contains(fruit.id)
        fruitId = fruit.id
        collectionView.reloadData()
    }
    
 
  @IBAction func likePressed(_ sender: Any) {
        guard let fruitId = fruitId else {
            return
        }
        
        if likeButton.isSelected {
            UserManager.dislikeFruit(fruitId) {
                self.likeButton.isSelected.toggle()
            }
        } else {
            UserManager.likeFruit(fruitId) {
                self.likeButton.isSelected.toggle()
            }
        }
    }
}

extension ShopCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 285, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension ShopCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.getPhotosCount(for: fruitId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(at: indexPath, type: ImageCollectionViewCell.self)
        if let imagePath = DataManager.getPhotoUrl(for: fruitId, index: indexPath.item) {
            let ref = Storage.storage().reference(withPath: imagePath)
            cell.photoImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.layer.cornerRadius = 0
        return cell
    }
}

