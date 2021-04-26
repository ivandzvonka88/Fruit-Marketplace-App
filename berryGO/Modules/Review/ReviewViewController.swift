//
//  ReviewViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 08.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import FloatingPanel

class ReviewViewController: UIViewController, Storyboarded, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var photocollectionView: UICollectionView!
  
    var sectionTitles = [nil, "Marks", "Review"]
    var photos = [UIImage]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(with: RateItWithoutButtonTableViewCell.self)
        tableView.registerNib(with: MarksTableViewCell.self)
        tableView.registerNib(with: MustTryTableViewCell.self)
        tableView.registerNib(with: WriteReviewTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        addButton.layer.cornerRadius = 24
      
        photocollectionView.registerNib(with: AddCollectionViewCell.self)
        photocollectionView.registerNib(with: ImageCollectionViewCell.self)
        photocollectionView.delegate = self
        photocollectionView.dataSource = self
        photocollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info = sender.userInfo else { return }
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
//        let bottomSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 72, right: 0)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        view.layoutIfNeeded()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if let floatingPanelVC = parent as? FloatingPanelController {
            floatingPanelVC.removePanelFromParent(animated: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
}

extension ReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionTitle = sectionTitles[section] else {
            return UIView()
        }

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let label = UILabel(frame: CGRect(x: 28, y: 30, width: tableView.frame.width - 28, height: 20))
        label.text = sectionTitle
        label.textColor = UIColor(named: "black80Alpha")
        label.font = UIFont.Rubik(.medium, size: 16)
        headerView.addSubview(label)
        return headerView
    }
}

extension ReviewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueCell(for: indexPath, type: RateItWithoutButtonTableViewCell.self)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueCell(for: indexPath, type: MustTryTableViewCell.self)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueCell(for: indexPath, type: MarksTableViewCell.self)
            return cell
        } else {
            let cell = tableView.dequeueCell(for: indexPath, type: WriteReviewTableViewCell.self)
            cell.textChanged {[weak tableView] (_) in
                DispatchQueue.main.async {
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
            }
            return cell
        }
    }
}

class ReviewPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition = .full
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        if position == .full {
            return 20
        } else {
            return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> = [.full, .hidden]
}

extension ReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension ReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == self.getPhotosCount() else {
            return
        }
        
        self.addPhotoPressed()
    }
}

extension ReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (self.getPhotosCount() )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.getPhotosCount() {
            let cell = collectionView.dequeueCell(at: indexPath, type: AddCollectionViewCell.self)
            cell.addphoto.image = UIImage(named: ("add_photo2.png"))
            cell.layer.cornerRadius = 3
            return cell
        } else {
            let cell = collectionView.dequeueCell(at: indexPath, type: ImageCollectionViewCell.self)
            cell.photoImageView.image = self.getPhoto(indexPath.row)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.deleteButton.isHidden = false
            cell.layer.cornerRadius = 3
            return cell
        }
    }
}

extension ReviewViewController: ImageCollectionViewCellDelegate {
    func deleteButtonPressed(_ indexPath: IndexPath) {
        self.deletePhotoPressed(indexPath.row)
    }
}
extension ReviewViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        picker.dismiss(animated: true)
        photos.append(image)
        photocollectionView.reloadData()
        self.addButton.isSelected.toggle()
    }
}
