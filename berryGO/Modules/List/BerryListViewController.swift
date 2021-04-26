//
//  BerryListViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 20.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit
import FloatingPanel

class BerryListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, Storyboarded {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fruitsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filtercollection: UICollectionView!
  
    var filter_condition = 0
  
    var data = [FruitViewModel]() {
        didSet {
            filterData(using: searchBar.text)
            refreshData()
        }
    }
    var filteredData = [FruitViewModel]() {
        didSet {
            refreshData()
        }
    }
    var items = ["sort1.png", "sort2.png", "sort6.png", "sort3.png", "sort4.png", "sort5.png"]
    var s_items = ["sort1.png", "s_sort2.png", "s_sort6.png", "s_sort3.png", "s_sort4.png", "s_sort5.png"]
    var filters = [0, 0, 0, 0, 0, 0]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(with: FruitTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 80, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.white
        filtercollection.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        //searchBar.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        //filtercollection.register(UINib.init(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filtercollectionviewcell")
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        UserManager.openProfileScreen()
    }

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercollectionviewcell", for: indexPath as IndexPath) as! FilterCollectionViewCell
      if self.filters[indexPath.item] == 0{
          cell.filter_img.image = UIImage(named: (self.items[indexPath.item]))
      } else {
          cell.filter_img.image = UIImage(named: (self.s_items[indexPath.item]))
      }
      return cell
    }
   
    // MARK: - UICollectionViewDelegate protocol
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if indexPath.item == 0{
         return
      }
      if indexPath.item > 0 {
          let cell = self.filtercollection.cellForItem(at: indexPath) as! FilterCollectionViewCell
          if self.filters[indexPath.item] == 0{
              self.filters[indexPath.item] = 1
              cell.filter_img.image = UIImage(named: (self.s_items[indexPath.item]))
          } else {
              cell.filter_img.image = UIImage(named: (self.items[indexPath.item]))
              self.filters[indexPath.item] = 0
          }
      }
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
        fruitsLabel.text = "\(filteredData.count) fruits"
        tableView.reloadData()
    }
}
extension BerryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 105
        if indexPath.item == 1 {
            width = 93
        }
        if indexPath.item == 2 {
            width = 68
        }
        if indexPath.item == 3 {
            width = 102
        }
        if indexPath.item == 4 {
            width = 87
        }
        if indexPath.item == 5 {
            width = 77
        }
        return CGSize(width: CGFloat(width), height: 31)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension BerryListViewController: UITableViewDataSource {
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

extension BerryListViewController: UITableViewDelegate {
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

extension BerryListViewController: MapViewControllerDelegate {
    func fruitsWereDisplayed(_ fruits: [FruitViewModel]) {
        data = fruits
    }
    
    func cityWasDisplayed(_ cityName: String?) {
        cityLabel.text = cityName
    }
    
    func filterData(using searchQuery: String?) {
        guard let searchText = searchQuery, searchText.count > 0 else {
            filteredData = data
            return
        }
        
        filteredData = data.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

extension BerryListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        (parent as? FloatingPanelController)?.move(to: .full, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(using: searchText)
    }
}
