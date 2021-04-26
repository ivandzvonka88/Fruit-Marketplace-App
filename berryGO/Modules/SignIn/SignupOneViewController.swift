//
//  SignupOneViewController.swift
//  berryGO
//
//  Created by admin on 11/11/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class SignupOneViewController: UIViewController, Storyboarded {

  @IBOutlet weak var myView: UIView!
  @IBOutlet weak var email_field: BGTextField!
  @IBOutlet weak var password_field: BGTextField!
  override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 24
        // Do any additional setup after loading the view.
    }
 
  @IBAction func backTapped(_ sender: Any) {
      navigationController?.popViewController(animated: true)
  }
  @IBAction func closeTapped(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
  }
  @IBAction func continueTapped(_ sender: Any) {
      let registrationVC = SignupTwoViewController.instantiate(fromStoryboard: "SignIn")
      navigationController?.pushViewController(registrationVC, animated: true)
  }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
