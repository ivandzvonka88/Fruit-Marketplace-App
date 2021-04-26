//
//  WriteReviewTableViewCell.swift
//  berryGO
//
//  Created by Evgeny Gusev on 10.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class WriteReviewTableViewCell: UITableViewCell, ReusableItem, UITextViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var textChanged: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
//        containerView.layer.cornerRadius = 10
//        containerView.layer.borderWidth = 1
//        containerView.layer.borderColor = UIColor(named: "paleGray")?.cgColor ?? UIColor.lightGray.cgColor
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
        textChanged?(textView.text)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textChanged = nil
    }
}
