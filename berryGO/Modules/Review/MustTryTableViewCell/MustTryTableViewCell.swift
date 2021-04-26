//
//  MustTryTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 10.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class MustTryTableViewCell: UITableViewCell, ReusableItem {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        containerView.layer.cornerRadius = 10
//        containerView.layer.borderWidth = 1
//        containerView.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
//        if sender.isOn {
//            containerView.layer.borderColor = UIColor(named: "solidOrangeColor")?.cgColor ?? UIColor.orange.cgColor
//        } else {
//            containerView.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
//        }
    }
    
    @IBAction func questionMarkPressed(_ sender: Any) {
        print("todo")
    }
}
