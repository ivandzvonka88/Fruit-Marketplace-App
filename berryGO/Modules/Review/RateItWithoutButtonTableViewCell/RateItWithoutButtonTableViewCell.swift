//
//  RateItWithoutButtonTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 08.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Cosmos

class RateItWithoutButtonTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        containerView.layer.cornerRadius = 10
//        containerView.layer.borderWidth = 1
//        containerView.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
    }
}
