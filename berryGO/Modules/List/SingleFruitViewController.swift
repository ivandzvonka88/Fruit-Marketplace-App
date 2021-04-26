//
//  SingleFruitViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 02.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class SingleFruitViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView1: UIView!
    @IBOutlet weak var emptyView2: UIView!
    @IBOutlet weak var closeButton: UIButton!
  
    var fruit: FruitViewModel? {
        didSet {
            //tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(with: SingleFruitTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 12
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        emptyView1.addGestureRecognizer(tap1)
        emptyView2.addGestureRecognizer(tap2)
    }
    
  @IBAction func closeTapped(_ sender: Any) {
      self.dismiss(animated: true){
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
      }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshData() {
        tableView.reloadData()
    }
}

extension SingleFruitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruit == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath, type: SingleFruitTableViewCell.self)
        if let fruit = fruit {
            cell.configure(with: fruit)
        }
        return cell
    }
}

extension SingleFruitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fruitVC = FruitViewController.instantiate(fromStoryboard: "Fruit")
        fruitVC.fruit = fruit
        navigationController?.pushViewController(fruitVC, animated: true)
    }
}
