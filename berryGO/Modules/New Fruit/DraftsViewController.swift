//
//  DraftsViewController.swift
//  berryGO
//
//  Created by admin on 11/18/20.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class DraftsViewController: UIViewController, Storyboarded {

  @IBOutlet weak var drafttable: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
        
        drafttable.registerNib(with: DraftTableViewCell.self)
        drafttable.contentInsetAdjustmentBehavior = .never
        drafttable.dataSource = self
        drafttable.delegate = self
    
        // Do any additional setup after loading the view.
    }
    
  @IBAction func backTapped(_ sender: Any) {
      navigationController?.popViewController(animated: true)
  }
  @IBAction func editTapped(_ sender: Any) {
  }


}
extension DraftsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drafttable.dequeueCell(for: indexPath, type: DraftTableViewCell.self)
        return cell
    }
}

extension DraftsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
