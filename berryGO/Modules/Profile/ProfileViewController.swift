//
//  ProfileViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 24.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ProfileViewController: UIViewController, Storyboarded {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data = [FruitViewModel]() {
        didSet {
            filterData(using: searchBar.text)
            tableView.reloadData()
        }
    }
    var filteredData = [FruitViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileButton.layer.cornerRadius = 24
        profileButton.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        profileButton.layer.borderWidth = 1
        tableView.registerNib(with: FruitTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        guard let currentUser = Auth.auth().currentUser, let location = CLLocationManager().location else {
            return
        }
        
        profileButton.setTitle(currentUser.displayName ?? "Edit Profile", for: .normal)
        
        guard UserManager.likedFruits.count > 0 else {
            return
        }
        
        Firestore.firestore().collection("fruits").whereField(FieldPath.documentID(), in: UserManager.likedFruits).getDocuments { (query, error) in
            guard let query = query else {
                return
            }
            
            var result = [FruitViewModel]()
            for fruitDoc in query.documents {
                if let fruit = FruitViewModel(fruitDoc.data(), id: fruitDoc.documentID, location: location) {
                    result.append(fruit)
                }
            }
            self.data = result
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        let myDetailsViewController = MyDetailsViewController.instantiate(fromStoryboard: "Profile")
        navigationController?.pushViewController(myDetailsViewController, animated: true)
    }
    
    func filterData(using searchQuery: String?) {
        guard let searchText = searchQuery, searchText.count > 0 else {
            filteredData = data
            return
        }
        
        filteredData = data.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath, type: FruitTableViewCell.self)
        cell.configure(with: filteredData[indexPath.section])
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fruitVC = FruitViewController.instantiate(fromStoryboard: "Fruit")
        fruitVC.fruit = filteredData[indexPath.section]
        navigationController?.pushViewController(fruitVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ProfileViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(using: searchText)
    }
}
