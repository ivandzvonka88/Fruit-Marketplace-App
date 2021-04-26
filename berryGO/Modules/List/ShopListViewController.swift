//
//  ShopListViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class ShopListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var fruitsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var emptyView1: UIView!
    @IBOutlet weak var emptyView2: UIView!
    @IBOutlet weak var mycollectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var myView: UIView!
  
    var shop: Shop? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.layer.cornerRadius = 12
        mycollectionView.registerNib(with: ShopCollectionViewCell.self)
        mycollectionView.delegate = self
        mycollectionView.dataSource = self
        mycollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        guard let unwrappedShop = shop else {
            return
        }
        shopNameLabel.text = unwrappedShop.name
        let metersInMile: Double = 1609
        distanceLabel.text = "\(String(format: "%.1f", unwrappedShop.distance / metersInMile)) miles"
        fruitsLabel.text = "\(unwrappedShop.fruits.count) fruits"
      
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        emptyView1.addGestureRecognizer(tap1)
        emptyView2.addGestureRecognizer(tap2)
    }
  
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
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
    
  @IBAction func closeTapped(_ sender: Any) {
      self.dismiss(animated: true){
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
      }
  }
  override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshData() {
        mycollectionView.reloadData()
    }
}
extension ShopListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 285, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension ShopListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop?.fruits.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(at: indexPath, type: ShopCollectionViewCell.self)
        if let fruits = shop?.fruits {
            cell.configure(with: fruits[indexPath.item])
        }
        cell.layer.cornerRadius = 8
      cell.layer.borderColor = UIColor.lightGray.cgColor
      cell.layer.borderWidth = 0.3
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fruitVC = FruitViewController.instantiate(fromStoryboard: "Fruit")
        fruitVC.fruit = shop?.fruits[indexPath.item]
        navigationController?.pushViewController(fruitVC, animated: true)
    }
}
