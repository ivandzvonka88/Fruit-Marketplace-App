//
//  NSMutableAttributedString.swift
//  berryGO
//
//  Created by Evgeny Gusev on 23.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult func black50(_ text: String, size: CGFloat = 14) -> NSMutableAttributedString {
      let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.Rubik(.regular, size: size),
                                                    NSAttributedString.Key.foregroundColor: UIColor(named: "txtColor2") ?? UIColor.black]
        let normal = NSMutableAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
    
    @discardableResult func black80Medium(_ text: String, size: CGFloat = 14) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.Rubik(.medium, size: size),
                                                    NSAttributedString.Key.foregroundColor: UIColor(named: "txtColor") ?? UIColor.black]
        let normal = NSMutableAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
}
