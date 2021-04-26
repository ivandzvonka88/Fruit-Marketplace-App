//
//  DraftTableViewCell.swift
//  berryGO
//
//  Created by admin on 11/18/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Cosmos

class DraftTableViewCell: UITableViewCell, ReusableItem {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: CosmosView!
  @IBOutlet weak var reviewLabel: UILabel!
  @IBOutlet weak var photoImage: UIImageView!
  @IBOutlet weak var storeLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImage.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
