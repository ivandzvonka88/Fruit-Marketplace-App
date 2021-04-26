//
//  MyDetailsViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 24.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Firebase

class MyDetailsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var nameTextField: BGTextField!
    @IBOutlet weak var emailTextField: BGTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        nameTextField.text = user.displayName
        emailTextField.text = user.email
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let editDetailsVC = EditDetailsViewController.instantiate(fromStoryboard: "Profile")
        navigationController?.pushViewController(editDetailsVC, animated: true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserManager.likedFruits = []
            NotificationCenter.default.post(Notification(name: AppDelegate.userDataChanged))
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
