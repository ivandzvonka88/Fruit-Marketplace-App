//
//  Review.swift
//  berryGO
//
//  Created by Evgeny Gusev on 21.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Review {
    var user: String
    var rating: Double
    var text: String
    var date: String
    
    init?(_ dict: [String: Any]?) {
        guard let dict = dict else {
            return nil
        }
        
        self.user = dict["userName"] as? String ?? ""
        self.rating = dict["rating"] as? Double ?? 0.0
        self.text = dict["text"] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        self.date = dateFormatter.string(from: (dict["date"] as? Timestamp)?.dateValue() ?? Date())
    }
}
