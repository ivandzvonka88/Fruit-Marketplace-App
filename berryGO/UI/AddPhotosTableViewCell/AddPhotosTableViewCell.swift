//
//  AddPhotosTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 10.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

protocol AddPhotosTableViewCellDelegate: AnyObject {
    func addPhotoPressed()
    func deletePhotoPressed(_ index: Int)
}

protocol AddPhotosTableViewCellDataSource: AnyObject {
    func getPhotosCount() -> Int
    func getPhoto(_ index: Int) -> UIImage?
}

class AddPhotosTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: AddPhotosTableViewCellDelegate?
    weak var dataSource: AddPhotosTableViewCellDataSource? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(with: AddCollectionViewCell.self)
        collectionView.registerNib(with: ImageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension AddPhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension AddPhotosTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == dataSource?.getPhotosCount() else {
            return
        }
        
        delegate?.addPhotoPressed()
    }
}

extension AddPhotosTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (dataSource?.getPhotosCount() ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == dataSource?.getPhotosCount() {
            let cell = collectionView.dequeueCell(at: indexPath, type: AddCollectionViewCell.self)
            return cell
        } else {
            let cell = collectionView.dequeueCell(at: indexPath, type: ImageCollectionViewCell.self)
            cell.photoImageView.image = dataSource?.getPhoto(indexPath.row)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.deleteButton.isHidden = false
            return cell
        }
    }
}

extension AddPhotosTableViewCell: ImageCollectionViewCellDelegate {
    func deleteButtonPressed(_ indexPath: IndexPath) {
        delegate?.deletePhotoPressed(indexPath.row)
    }
}
