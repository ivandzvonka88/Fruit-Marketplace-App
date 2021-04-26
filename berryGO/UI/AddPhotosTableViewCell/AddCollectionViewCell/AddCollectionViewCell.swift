//
//  AddCollectionViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 10.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell, ReusableItem {

  @IBOutlet weak var addphoto: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
}
