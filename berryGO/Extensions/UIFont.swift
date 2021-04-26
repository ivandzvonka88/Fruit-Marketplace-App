//
//  UIFont.swift
//  berryGO
//
//  Created by Evgeny Gusev on 08.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

enum RubikStyle: String {
    case medium = "Medium"
    case regular = "Regular"
    case light = "Light"
}

extension UIFont {
    static func Rubik(_ style: RubikStyle, size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-\(style.rawValue)", size: size)!
    }
}
