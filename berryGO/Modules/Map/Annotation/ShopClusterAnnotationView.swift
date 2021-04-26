//
//  ShopClusterAnnotationView.swift
//  berryGO
//
//  Created by Evgeny Gusev on 20.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit
import MapKit

class ShopClusterAnnotationView: MKAnnotationView {

    let label: UILabel

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.frame.width / 2
        addSubview(label)
        
        guard let annotation = annotation as? MKClusterAnnotation else { return }
        label.text = "\(annotation.memberAnnotations.count)"
        label.textAlignment = .center
        label.font = UIFont(name: "Rubik-Medium", size: 16.0)
        label.textColor = UIColor(red: 1, green: 171 / 255, blue: 93 / 255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
