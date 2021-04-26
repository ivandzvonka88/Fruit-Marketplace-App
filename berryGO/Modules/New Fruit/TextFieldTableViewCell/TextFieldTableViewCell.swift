//
//  TextFieldTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 12.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
