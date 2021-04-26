//
//  SubmitButtonTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 12.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class SubmitButtonTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var submitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        submitButton.layer.cornerRadius = 24
    }
    
    @IBAction func submitPressed(_ sender: Any) {
    }
}
