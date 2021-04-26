//
//  ShopAnnotation.swift
//  berryGO
//
//  Created by Evgeny Gusev on 15.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import MapKit

class ShopAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var id: String
    
    init(coordinate: CLLocationCoordinate2D, id: String, image: UIImage?) {
        self.coordinate = coordinate
        self.image = image
        self.id = id
    }
    
    func getImage() -> UIImage? {
        return image
    }
}
