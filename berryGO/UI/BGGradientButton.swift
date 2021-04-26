//
//  BGGradientButton.swift
//  berryGO
//
//  Created by Evgeny Gusev on 25.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

@IBDesignable
class BGGradientButton: BGButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        let startColor = UIColor(red: 1, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)
        let endColor = UIColor(red: 1, green: 135.0/255.0, blue: 84.0/255.0, alpha: 1)
        addLinearGradient(from: startColor, to: endColor, type: .diagonal)
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { sublayer in
            if sublayer is CAGradientLayer {
                sublayer.frame = bounds
            }
        }
    }
}
