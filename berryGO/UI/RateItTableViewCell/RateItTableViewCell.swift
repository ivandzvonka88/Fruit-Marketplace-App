//
//  RateItTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 04.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Cosmos

protocol RateItTableViewCellDelegate: AnyObject {
    func showReviewScreen(_ rating: Double)
    func ratingWasProvided(_ rating: Double)
}

class RateItTableViewCell: UITableViewCell, ReusableItem {
    @IBOutlet weak var rateItBackgroundView: UIView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    weak var delegate: RateItTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        rateItBackgroundView.layer.cornerRadius = 10
//        writeReviewButton.layer.cornerRadius = 10
    }
    
    @IBAction func writeReviewPressed(_ sender: Any) {
        delegate?.showReviewScreen(rateView.rating)
    }
}
