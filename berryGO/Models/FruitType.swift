//
//  ShopType.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

enum FruitType {
    case leaf
    case fruit
    case saved
    var image: UIImage? {
        get {
            switch self {
            case .fruit:
                return UIImage(named: "fruit")
            case .leaf:
                return UIImage(named: "leaf")
            case .saved:
                return UIImage(named: "fruit")
          }
        }
    }
    var pin_image: UIImage? {
        get {
            switch self {
            case .fruit:
                return UIImage(named: "pin_fruit")
            case .leaf:
                return UIImage(named: "leaf")
            case .saved:
              return UIImage(named: "pin_saved")
            }
        }
    }
    var selected_image: UIImage? {
        get {
            switch self {
            case .fruit:
                return UIImage(named: "selected_fruit")
            case .leaf:
                return UIImage(named: "leaf")
            case .saved:
              return UIImage(named: "selected_saved")
            }
        }
    }
}
