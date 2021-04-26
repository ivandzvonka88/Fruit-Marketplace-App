//
//  ImageCollectionViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 20.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func deleteButtonPressed(_ indexPath: IndexPath)
}

class ImageCollectionViewCell: UICollectionViewCell, ReusableItem {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    var indexPath: IndexPath?
    weak var delegate: ImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        photoImageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        
        delegate?.deleteButtonPressed(indexPath)
    }
}
