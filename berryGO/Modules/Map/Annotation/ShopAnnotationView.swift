//
//  ShopAnnotationView.swift
//  berryGO
//
//  Created by Evgeny Gusev on 15.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit
import MapKit

class ShopAnnotationView: MKAnnotationView {
    
    let imageView = UIImageView()
    let size: CGFloat = 32
    var imageSize: CGFloat {
        get {
            return size / 2
        }
    }
    var imageOffset: CGFloat {
        get {
            return size / 4
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    init(annotation: ShopAnnotation, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.frame = CGRect(x: 0, y: 0, width: 36, height: 42)
        self.imageView.frame = CGRect(x: 0, y: 0, width: 36, height: 42)
        self.imageView.contentMode = .scaleAspectFit

        self.imageView.layer.masksToBounds = false
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOpacity = 0.3
        self.imageView.layer.shadowOffset = CGSize(width:0.5, height:1)
        self.imageView.layer.shadowRadius = 0.5
        
        if annotation is ShopAnnotation {
            imageView.image = (annotation as! ShopAnnotation).getImage()
        }
        addSubview(imageView)
        clusteringIdentifier = String(describing: ShopAnnotationView.self)
    }
}
