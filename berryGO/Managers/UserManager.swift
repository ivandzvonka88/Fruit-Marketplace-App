//
//  UserManager.swift
//  berryGO
//
//  Created by Evgeny Gusev on 22.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    typealias FirebaseClosure = (String) -> ()
    typealias LoggedInCallback = () -> ()
    static var likedFruits = [String]()
  
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    static func loadLikedFruits(callback: FirebaseClosure? = nil) {
        guard let userId = Auth.auth().currentUser?.uid else {
            callback?("")
            return
        }
        
        Firestore.firestore().collection("users/\(userId)/likedFruits").getDocuments { (query, error) in
            guard let query = query else {
                callback?("")
                return
            }
            
            likedFruits = query.documents.compactMap { $0.documentID }
            callback?(userId)
        }
    }
    
    static func likeFruit(_ fruitID: String, callback: @escaping LoggedInCallback) {
        let firebaseClosure: FirebaseClosure = { id in
            Firestore.firestore().collection("users/\(id)/likedFruits")
                .document(fruitID)
                .setData(["date": Timestamp(date: Date())])
            likedFruits.append(fruitID)
            callback()
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            openSignInScreen(callback: firebaseClosure)
            return
        }
        
        firebaseClosure(userId)
    }
    
    static func dislikeFruit(_ fruitID: String, callback: @escaping LoggedInCallback) {
        let firebaseClosure: FirebaseClosure = { id in
            Firestore.firestore().collection("users/\(id)/likedFruits")
                .document(fruitID)
                .delete()
            likedFruits.removeAll { $0 == fruitID }
            callback()
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            openSignInScreen(callback: firebaseClosure)
            return
        }
        
        firebaseClosure(userId)
    }
    
    static func openProfileScreen() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        
        if Auth.auth().currentUser == nil {
            openSignInScreen { (_) in
                showProfileScreen()
            }
        } else {
            showProfileScreen()
        }
    }
    
    static private func showProfileScreen() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        
        let profileVC = ProfileViewController.instantiate(fromStoryboard: "Profile")
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    static private func openSignInScreen(callback: @escaping FirebaseClosure) {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        let signInViewController = SignInViewController.instantiate(fromStoryboard: "SignIn")
        signInViewController.callback = callback
        let nc = UINavigationController(rootViewController: signInViewController)
        nc.navigationBar.isHidden = true
        navigationController.present(nc, animated: true)
    }
}
