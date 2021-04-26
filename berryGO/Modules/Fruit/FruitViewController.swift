//
//  FruitViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 08.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import FloatingPanel
import FirebaseFirestore

class FruitViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favButton: UIButton!
    
    var fruit: FruitViewModel!
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(with: FruitExpandedTableViewCell.self)
        tableView.registerNib(with: ReviewTableViewCell.self)
        tableView.registerNib(with: RateItTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        Firestore.firestore().collection("fruits/\(fruit.id)/reviews").getDocuments { (query, error) in
            guard let query = query else {
                return
            }
            
            query.documents.forEach { document in
                if let review = Review(document.data()) {
                    self.reviews.append(review)
                }
            }
            
            self.tableView.reloadData()
        }
        favButton.isSelected = UserManager.likedFruits.contains(fruit.id)
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.handleModalDismissed),
            name: NSNotification.Name(rawValue: "photoTapped"),
            object: nil)
          
        
    }
  
    @objc func handleModalDismissed() {
        let photoVC = CustomPhotoViewController.instantiate(fromStoryboard: "Fruit")
        photoVC.fruit = self.fruit
        navigationController?.pushViewController(photoVC, animated: true)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(refreshData),
                                               name: AppDelegate.userDataChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(refreshData),
                                               name: AppDelegate.fruitsDataChanged,
                                               object: nil)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshData() {
        tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        if favButton.isSelected {
            UserManager.dislikeFruit(fruit.id) {
                self.favButton.isSelected.toggle()
            }
        } else {
            UserManager.likeFruit(fruit.id) {
                self.favButton.isSelected.toggle()
            }
        }
    }
}

extension FruitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviews.count > 0 ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? reviews.count : 1
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueCell(for: indexPath, type: FruitExpandedTableViewCell.self)
            cell.configure(with: fruit)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueCell(for: indexPath, type: RateItTableViewCell.self)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueCell(for: indexPath, type: ReviewTableViewCell.self)
            cell.photo_count = indexPath.row
            cell.configure(reviews[indexPath.row])
            return cell
        }
    }
}

extension FruitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0}
        return section == 2 ? 48 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 2 else {
            return UIView()
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48))
        let label = UILabel(frame: CGRect(x: 20, y: 28, width: tableView.frame.width - 20, height: 20))
        label.text = "Reviews (\(fruit.reviews))"
        label.textColor = UIColor(named: "txtColor")
        label.font = UIFont.Rubik(.medium, size: 16)
        headerView.addSubview(label)
        return headerView
    }
}

extension FruitViewController: RateItTableViewCellDelegate {
    func showReviewScreen(_ rating: Double) { // todo
        let floatingPanelController = FloatingPanelController()
        let contentVC = ReviewViewController.instantiate(fromStoryboard: "Review")
        floatingPanelController.set(contentViewController: contentVC)
        floatingPanelController.track(scrollView: contentVC.tableView)
            floatingPanelController.contentInsetAdjustmentBehavior = .never
        floatingPanelController.delegate = self
        floatingPanelController.addPanel(toParent: self)
        floatingPanelController.surfaceView.layer.cornerRadius = 20
        floatingPanelController.surfaceView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        floatingPanelController.surfaceView.layer.masksToBounds = true
    }
    
    func ratingWasProvided(_ rating: Double) {
        // todo
    }
}

extension FruitViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ReviewPanelLayout()
    }
}
