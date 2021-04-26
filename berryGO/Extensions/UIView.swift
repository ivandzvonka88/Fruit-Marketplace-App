//
//  UIView.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

enum GradientType {
    case vertical
    case horizontal
    case diagonal
    
    var startPoint: CGPoint {
        get {
            switch self {
            case .vertical:
                return CGPoint(x: 0.5, y: 0)
            case .horizontal:
                return CGPoint(x: 0, y: 0.5)
            case .diagonal:
                return CGPoint(x: 0, y: 1)
            }
        }
    }
    
    var endPoint: CGPoint {
        get {
            switch self {
            case .vertical:
                return CGPoint(x: 0.5, y: 1)
            case .horizontal:
                return CGPoint(x: 1, y: 0.5)
            case .diagonal:
                return CGPoint(x: 1, y: 0)
            }
        }
    }
}

extension UIView {
    func addLinearGradient(_ colors: [UIColor], type: GradientType) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.startPoint = type.startPoint
        gradientLayer.endPoint = type.endPoint
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addLinearGradient(from: UIColor, to: UIColor, type: GradientType) {
        addLinearGradient([from, to], type: type)
    }
}
