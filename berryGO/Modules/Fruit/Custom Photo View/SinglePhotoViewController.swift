//
//  SinglePhotoViewController.swift
//  berryGO
//
//  Created by admin on 11/4/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import FloatingPanel
import FirebaseFirestore
import FirebaseStorage

class SinglePhotoViewController: UIViewController, Storyboarded {

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var profilePhoto: UIImageView!
  @IBOutlet weak var profileName: UILabel!
  @IBOutlet weak var fruitPhoto: UIImageView!
  
  var fruit: FruitViewModel!
  var fruitId: String?
  var currentImage: Int?
  var totalCount: Int?
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        fruitId = fruit.id
        totalCount = DataManager.getPhotosCount(for: fruitId)
    
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        if (currentImage == nil) {
          currentImage = 0;
        }
        fruitPhoto.contentMode = .scaleAspectFit
        let imagePath = DataManager.getPhotoUrl(for: fruitId, index: currentImage!)
        let ref = Storage.storage().reference(withPath: imagePath!)
        fruitPhoto.sd_setImage(with: ref, placeholderImage: UIImage(named: "placeholder"))

        // Do any additional setup after loading the view.
  }
  @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
          
      if (sender.direction == .left) {
          if currentImage == totalCount! - 1 {
              currentImage = 0
          }else{
              currentImage! += 1
          }
      }
          
      if (sender.direction == .right) {
          if currentImage == 0 {
              currentImage = totalCount! - 1
          }else{
              currentImage! -= 1
          }
      }
      let imagePath = DataManager.getPhotoUrl(for: fruitId, index: currentImage!)
      let ref = Storage.storage().reference(withPath: imagePath!)
      fruitPhoto.sd_setImage(with: ref, placeholderImage: UIImage(named: "placeholder"))
  }
  
  @IBAction func bavkButtonTapped(_ sender: Any) {
      navigationController?.popViewController(animated: true)
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
