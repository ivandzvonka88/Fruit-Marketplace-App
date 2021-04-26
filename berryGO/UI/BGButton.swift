//
//  BGButton.swift
//  berryGO
//
//  Created by Evgeny Gusev on 24.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

@IBDesignable
class BGButton: UIButton {
    
    @IBInspectable
    var disabledAlpha: CGFloat = 0.45
    
    override var isEnabled: Bool {
        didSet {
            updateAlpha()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAlpha()
    }
    
    private func updateAlpha() {
        alpha = isEnabled ? 1.0 : disabledAlpha
    }
}
