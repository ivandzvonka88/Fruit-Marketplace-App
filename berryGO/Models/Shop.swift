//
//  Shop.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

struct Shop {
    var id: String
    var name: String
    var distance: Double
    var fruits: [FruitViewModel]
    var location: CLLocation
    
    init?(_ fruit: FruitViewModel, location: CLLocation) {
        guard let name = fruit.shopName, let shopId = fruit.shopId else {
            return nil
        }
        
        self.fruits = [fruit]
        self.id = shopId
        self.name = name
        self.location = fruit.location
        self.distance = location.distance(from: fruit.location)
    }
    
    func getImage() -> UIImage? {
        return UIImage(named: "basket")
    }
    func getPinImage() -> UIImage? {
        return UIImage(named: "pin_basket")
    }
    func getSelectedImage() -> UIImage? {
         return UIImage(named: "selected_basket")
    }
}

extension Shop: Equatable {
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        return lhs.id == rhs.id
    }
}
