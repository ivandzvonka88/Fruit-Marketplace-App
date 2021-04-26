//
//  Fruit.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

struct FruitViewModel {
    var id: String
    var name: String
    var address: String
    var rating: Double
    var ratings: Int
    var reviews: Int
    var type: FruitType
    var distance: Double
    var location: CLLocation
    var shopName: String?
    var shopId: String?
    var date: String
    
    init?(_ dict: [String: Any]?, id: String, location: CLLocation) {
        guard let dict = dict, let geoPoint = dict["l"] as? GeoPoint else {
            return nil
        }
        
        self.id = id
        self.name = dict["name"] as? String ?? ""
        self.address = dict["address"] as? String ?? ""
        self.rating = dict["rating"] as? Double ?? 0.0
        self.shopId = dict["shopId"] as? String
        self.shopName = dict["shopName"] as? String
        self.type = .fruit
        self.distance = location.distance(from: geoPoint.locationValue())
        self.location = geoPoint.locationValue()
        self.ratings = dict["ratings"] as? Int ?? 0
        self.reviews = dict["reviews"] as? Int ?? 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        self.date = dateFormatter.string(from: (dict["date"] as? Timestamp)?.dateValue() ?? Date())
    }
    
    func getImage() -> UIImage? {
        return type.image
    }
    func getPinImage() -> UIImage? {
        return type.pin_image
    }
    func getSelectedImage() -> UIImage? {
      return type.selected_image
    }
    
    func getDistance() -> Double {
        return distance
    }
}

extension FruitViewModel: Equatable {
    static func == (lhs: FruitViewModel, rhs: FruitViewModel) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address
    }
}
