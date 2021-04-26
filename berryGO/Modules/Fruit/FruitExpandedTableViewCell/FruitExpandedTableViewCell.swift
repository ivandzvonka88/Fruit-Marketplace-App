//
//  PhotosTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 04.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import FirebaseStorage

class FruitExpandedTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var fruitId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerNib(with: ImageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
        addressContainerView.layer.cornerRadius = 15
        addressContainerView.layer.borderWidth = 0.8
        addressContainerView.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
    }
    
    func configure(with fruit: FruitViewModel) {
        fruitId = fruit.id
        typeImageView.image = fruit.getImage()
        fruitNameLabel.text = fruit.name
        ratingLabel.text = String(format: "%.1f", fruit.rating)
        var addressText = NSMutableAttributedString()
        if let shopName = fruit.shopName {
            addressText = addressText.black80Medium("\(shopName)\n")
        }
        addressText = addressText.black50(fruit.address, size: 14)
        addressLabel.attributedText = addressText
        let metersInMile: Double = 1609
        distanceLabel.text = "\(String(format: "%.1f", fruit.distance / metersInMile)) miles"
        ratingsLabel.text = "(\(fruit.ratings))"
        dateLabel.text = "Posted " + fruit.date
    }
}

extension FruitExpandedTableViewCell: UICollectionViewDataSource {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "photoTapped"), object: nil)
    }
}

extension FruitExpandedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 290, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
