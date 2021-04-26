//
//  MarksTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 08.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class MarksTableViewCell: UITableViewCell, ReusableItem {

  @IBOutlet weak var localButton: UIButton!
  @IBOutlet weak var inseasonButton: UIButton!
  @IBOutlet weak var dessertButton: UIButton!
  
    @IBOutlet var roundedViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        inSeasonButton.layer.cornerRadius = 10
//        inSeasonButton.layer.borderWidth = 1
//        inSeasonButton.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
//        
//        dessertButton.layer.cornerRadius = 10
//        dessertButton.layer.borderWidth = 1
//        dessertButton.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
//
//        roundedViews.forEach { $0.layer.cornerRadius = 10 }
    }
  @IBAction func localbuttonTapped(_ sender: Any) {
      self.localButton.isSelected.toggle()
//      if localButton.isSelected {
//          UserManager.dislikeFruit(fruit.id) {
//              self.localButton.isSelected.toggle()
//          }
//      } else {
//          UserManager.likeFruit(fruit.id) {
//              self.localButton.isSelected.toggle()
//          }
//      }
  }
  
  @IBAction func inseasonbuttonTapped(_ sender: Any) {
      self.inseasonButton.isSelected.toggle()
  }
  
  @IBAction func dessertbuttonTapped(_ sender: Any) {
      self.dessertButton.isSelected.toggle()
  }
  //    @IBAction func buttonPressed(_ sender: UIButton) {
//        sender.isSelected.toggle()
//        
//        if sender.isSelected {
//            sender.layer.borderColor = UIColor(named: "solidOrangeColor")?.cgColor ?? UIColor.orange.cgColor
//        } else {
//            sender.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
//        }
//    }
}
