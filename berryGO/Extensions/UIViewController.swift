//
//  UIViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 25.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        navigationController?.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
}
