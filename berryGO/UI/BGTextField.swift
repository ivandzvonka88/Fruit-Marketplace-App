//
//  BGTextField.swift
//  berryGO
//
//  Created by Evgeny Gusev on 12.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class BGTextField: UITextField {

    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    
    @IBInspectable
    var cornerRadius: CGFloat = 8 {
        didSet {
            updateCornerRadius(cornerRadius)
        }
    }
    
    var leftPadding: CGFloat = 20 {
        didSet {
            padding = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        updateCornerRadius(cornerRadius)
    }
    
    private func updateCornerRadius(_ value: CGFloat) {
        layer.cornerRadius = value
        layer.masksToBounds = value > 0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func isEmailValid() -> Bool {
        guard let email = text else {
            return false
        }
        
        let emailPattern = "^(?![-_\\.])(?!.*[-_\\.]$)(?!.*?[-_\\.][-_\\.])[A-Z0-9a-z-_\\.]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        guard let emailRegEx = try? NSRegularExpression(pattern: emailPattern, options: []) else { return false }
        let matches = emailRegEx.matches(in: email, options: [], range: NSRange(location: 0, length: email.count))
        
        guard let match = matches.first else {
            return false
        }
        
        return match.range.length == email.count
    }
}
