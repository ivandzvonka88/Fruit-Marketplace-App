//
//  Storyboarded.swift
//  berryGO
//
//  Created by Evgeny Gusev on 15.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate(fromStoryboard storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(fromStoryboard storyboardName: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
