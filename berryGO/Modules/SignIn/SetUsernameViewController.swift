//
//  SetUsernameViewController.swift
//  berryGO
//
//  Created by admin on 11/11/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class SetUsernameViewController: UIViewController, Storyboarded {

  @IBOutlet weak var myView: UIView!
  @IBOutlet weak var username_field: BGTextField!
  override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 24
        // Do any additional setup after loading the view.
    }
  @IBAction func loginTapped(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func backTapped(_ sender: Any) {
      navigationController?.popViewController(animated: true)
  }
  
  @IBAction func closeTapped(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
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
