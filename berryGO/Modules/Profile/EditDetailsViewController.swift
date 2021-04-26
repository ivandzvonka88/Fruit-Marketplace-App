//
//  EditDetailsViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 25.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Firebase

class EditDetailsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: BGTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        nameTextField.delegate = self
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        nameTextField.text = user.displayName
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let name = nameTextField.text, name.count > 2 else {
            showAlert(with: "Name is too short")
            return
        }
        
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = name
        request?.commitChanges(completion: { (error) in
            if let error = error {
                self.showAlert(with: error.localizedDescription)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension EditDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
