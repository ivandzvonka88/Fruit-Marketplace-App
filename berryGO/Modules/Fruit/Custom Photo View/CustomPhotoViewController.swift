//
//  CustomPhotoViewController.swift
//  berryGO
//
//  Created by admin on 11/3/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import FirebaseStorage
import FloatingPanel
import FirebaseFirestore

class CustomPhotoViewController: UIViewController, Storyboarded {

  @IBOutlet weak var fruit_name: UILabel!
  @IBOutlet weak var Photocollection: UICollectionView!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var postButton: UIButton!
  
  var fruit: FruitViewModel!
  var fruitId: String?
  var width1: CGFloat?
  var width2: CGFloat?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        Photocollection.registerNib(with: ImageCollectionViewCell.self)
        fruitId = fruit.id
        var addressText = NSMutableAttributedString()
        addressText = addressText.black80Medium(fruit.name, size: 17)
        addressText = addressText.black50(" photos", size: 17)
        fruit_name.attributedText = addressText
        
    }
  func getwidth() {
      let width = Photocollection.bounds.width
      let lower : UInt32 = UInt32(width / 3)
      let upper : UInt32 = UInt32(2 * width / 3)
      width1 = CGFloat(arc4random_uniform(upper - lower) + lower)
      width2 = width - width1! - 2
  }
    
  @IBAction func backButtonTapped(_ sender: Any) {
      navigationController?.popViewController(animated: true)
  }
  
  @IBAction func postButtonTapped(_ sender: Any) {
      let photoVC = CameraRollViewController.instantiate(fromStoryboard: "Fruit")
      
      navigationController?.pushViewController(photoVC, animated: true)
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
extension CustomPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item % 2 == 0 {
          self.getwidth()
          return CGSize(width: self.width1!, height: 150)
        } else {
          return CGSize(width: self.width2!, height: 150)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoVC = SinglePhotoViewController.instantiate(fromStoryboard: "Fruit")
        photoVC.fruit = self.fruit
        photoVC.currentImage = indexPath.item
        navigationController?.pushViewController(photoVC, animated: true)
    }
}

extension CustomPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.getPhotosCount(for: fruitId)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(at: indexPath, type: ImageCollectionViewCell.self)
          if let imagePath = DataManager.getPhotoUrl(for: fruitId, index: indexPath.item) {
              let ref = Storage.storage().reference(withPath: imagePath)
              cell.photoImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "placeholder"))
          }
        cell.layer.cornerRadius = 0
        return cell
    }
}
