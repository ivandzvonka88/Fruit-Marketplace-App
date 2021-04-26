//
//  ReusableItem.swift
//  berryGO
//
//  Created by Evgeny Gusev on 20.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit

protocol ReusableItem {
    static var reuseID: String { get }
}

extension ReusableItem {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath, type: Cell.Type) -> Cell where Cell: ReusableItem {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseID, for: indexPath) as! Cell
    }
    
    func dequeueSupplementaryView<View: UICollectionReusableView>(at indexPath: IndexPath, ofKind kind: String, type: View.Type) -> View
        where View: ReusableItem {
            return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: View.reuseID, for: indexPath) as! View
    }
    
    func register<Cell: UICollectionViewCell>(_ type: Cell.Type) where Cell: ReusableItem {
        register(type, forCellWithReuseIdentifier: Cell.reuseID)
    }
    
    func registerNib<Cell: UICollectionViewCell>(with cellType: Cell.Type) where Cell: ReusableItem {
        let nib = UINib(nibName: Cell.reuseID, bundle: Bundle(for: cellType))
        register(nib, forCellWithReuseIdentifier: Cell.reuseID)
    }
    
    func registerSupplementaryView<View: UICollectionReusableView>(_ type: View.Type, ofKind kind: String) where View: ReusableItem {
        let nib = UINib(nibName: View.reuseID, bundle: Bundle(for: type))
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: View.reuseID)
    }
    
    func registerDecorationView<View: UICollectionReusableView>(_ type: View.Type) where View: ReusableItem {
        let nib = UINib(nibName: View.reuseID, bundle: Bundle(for: type))
        collectionViewLayout.register(nib, forDecorationViewOfKind: View.reuseID)
    }
}

extension UITableView {
    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath, type: Cell.Type) -> Cell where Cell: ReusableItem {
        return dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as! Cell
    }
    
    func register<Cell: UITableViewCell>(_ type: Cell.Type) where Cell: ReusableItem {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseID)
    }
    
    func registerNib<Cell: UITableViewCell>(with cellType: Cell.Type) where Cell: ReusableItem {
        let nib = UINib(nibName: Cell.reuseID, bundle: Bundle(for: cellType))
        register(nib, forCellReuseIdentifier: Cell.reuseID)
    }
}
