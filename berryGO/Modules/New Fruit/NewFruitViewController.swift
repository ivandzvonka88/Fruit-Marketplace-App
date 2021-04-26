//
//  NewFruitViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 10.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class NewFruitViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var draftButton: UIButton!
    @IBOutlet weak var photocollectionView: UICollectionView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var savedraftButton: UIButton!
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(with: TextFieldTableViewCell.self)
        tableView.registerNib(with: RateItTableViewCell.self)
        tableView.registerNib(with: SubmitButtonTableViewCell.self)
        tableView.registerNib(with: SelectStoreTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.layer.cornerRadius = 40
        tableView.clipsToBounds = true

        // Top Left Corner: .layerMinXMinYCorner
        // Top Right Corner: .layerMaxXMinYCorner
        // Bottom Left Corner: .layerMinXMaxYCorner
        // Bottom Right Corner: .layerMaxXMaxYCorner
      
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      
      
        photocollectionView.registerNib(with: AddCollectionViewCell.self)
        photocollectionView.registerNib(with: ImageCollectionViewCell.self)
        photocollectionView.delegate = self
        photocollectionView.dataSource = self
        photocollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    func addPhotoPressed() {
        presentImagePicker()
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = type
            self.present(pickerController, animated: true)
        }
    }
    
    private func presentImagePicker() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getPhoto(_ index: Int) -> UIImage? {
        guard index >= 0, index < photos.count else {
            return nil
        }
        return photos[index]
    }
    
    func deletePhotoPressed(_ index: Int) {
        photos.remove(at: index)
        photocollectionView.reloadData()
    }
  
    @IBAction func draftTapped(_ sender: Any) {
        let draftVC = DraftsViewController.instantiate(fromStoryboard: "NewFruit")
        navigationController?.pushViewController(draftVC, animated: true)
    }
    
    @IBAction func postTapped(_ sender: Any) {
        
    }
    
    @IBAction func savedraftTapped(_ sender: Any) {
        
    }
  
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension NewFruitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.section == 0 {
            let cell = tableView.dequeueCell(for: indexPath, type: TextFieldTableViewCell.self)
            cell.textField.placeholder = "Name, origin and other relevant info"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueCell(for: indexPath, type: TextFieldTableViewCell.self)
            cell.textField.placeholder = "Local name (optional)"
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueCell(for: indexPath, type: SelectStoreTableViewCell.self)
            return cell
        } else {
            let cell = tableView.dequeueCell(for: indexPath, type: RateItTableViewCell.self)
            return cell
        }
    }
}

extension NewFruitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
          return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension NewFruitViewController: UINavigationControllerDelegate {
}
extension NewFruitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 192, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

extension NewFruitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == self.getPhotosCount() else {
            return
        }
        
        self.addPhotoPressed()
    }
}

extension NewFruitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (self.getPhotosCount() )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.getPhotosCount() {
            let cell = collectionView.dequeueCell(at: indexPath, type: AddCollectionViewCell.self)
            cell.layer.cornerRadius = 7
          cell.layer.borderWidth = 0.7
            cell.layer.borderColor = UIColor.lightText.cgColor
            return cell
        } else {
            let cell = collectionView.dequeueCell(at: indexPath, type: ImageCollectionViewCell.self)
            cell.photoImageView.image = self.getPhoto(indexPath.row)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.deleteButton.isHidden = false
            cell.layer.cornerRadius = 7
          cell.layer.borderWidth = 0.7
            cell.layer.borderColor = UIColor.lightText.cgColor
            return cell
        }
    }
}

extension NewFruitViewController: ImageCollectionViewCellDelegate {
    func deleteButtonPressed(_ indexPath: IndexPath) {
        self.deletePhotoPressed(indexPath.row)
    }
}
extension NewFruitViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        picker.dismiss(animated: true)
        photos.append(image)
        photocollectionView.reloadData()
        self.postButton.isSelected.toggle()
    }
}
