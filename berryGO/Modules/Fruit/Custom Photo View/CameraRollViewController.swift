//
//  CameraRollViewController.swift
//  berryGO
//
//  Created by admin on 11/4/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class CameraRollViewController: UIViewController, Storyboarded {

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var CameraRollCollection: UICollectionView!
  @IBOutlet weak var rollButton: UIButton!
  
  var selected_count : Int?
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
  @IBAction func backButtonTapped(_ sender: Any) {
      navigationController?.popViewController(animated: true)
  }
  @IBAction func rollButtonTapped(_ sender: Any) {
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
extension CameraRollViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let fullwidth = CameraRollCollection.bounds.width
          let width = ( fullwidth - 10 ) / 3
          return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension CameraRollViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singlephotocollection", for: indexPath as IndexPath) as! SignlePhotoCollectionViewCell

        if(indexPath.item == 0) {
            cell.fruit_image.image = UIImage(named: "capture")
        } else {
            cell.fruit_image.image = UIImage(named: "straw")
        }
        cell.fruit_image.clipsToBounds = true
        cell.layer.cornerRadius = 5
        if (indexPath.item == 0){
          cell.mark_number.text = ""
          cell.mark_image.isHidden = true
        }
        cell.mark_number.text = String(indexPath.item)
        return cell
    }
}
