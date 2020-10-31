//
//  RemainderTableViewController.swift
//  Remaindzzers
//
//  Created by mazen baddad on 10/31/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

class RemainderTableViewController : UITableViewController {
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        setupTableView()
        setupNavigationITem()
        setupTheme()
    }
    
    fileprivate func setupTableView() {
        
    }
    
    fileprivate func setupNavigationITem() {
        navigationItem.title = "Remaindzzers"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRemainder))
    }
    
    @objc func addRemainder() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK:- Themed

extension RemainderTableViewController : Themed {
    
    func applyTheme(_ theme: Theme) {
        tableView.backgroundColor = theme.backgroundColor
    }
}
