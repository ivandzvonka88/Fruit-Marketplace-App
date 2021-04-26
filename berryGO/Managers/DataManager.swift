//
//  DataManager.swift
//  berryGO
//
//  Created by Evgeny Gusev on 25.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    static var photos = [String: [String]]()
    
    static func getPhotosCount(for fruitId: String?) -> Int {
        guard let fruitId = fruitId else {
            return 0
        }
        return photos[fruitId]?.count ?? 0
    }
    
    static func getPhotoUrl(for fruitId: String?, index: Int) -> String? {
        guard let fruitId = fruitId, let arr = photos[fruitId], arr.count > index, index >= 0 else {
            return nil
        }
        
        return arr[index]
    }
    
    static func loadPhotos(for fruitId: String) {
        let storageReference =  Storage.storage().reference().child("fruits/\(fruitId)")
        storageReference.listAll { (result, error) in
            if let error = error {
                print(error)
                return
            }
            photos[fruitId] = result.items.compactMap { $0.fullPath }
            NotificationCenter.default.post(Notification(name: AppDelegate.fruitsDataChanged))
        }
    }
}
