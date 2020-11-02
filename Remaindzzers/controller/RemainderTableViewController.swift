//
//  RemainderTableViewController.swift
//  Remaindzzers
//
//  Created by mazen baddad on 10/31/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

class RemainderTableViewController : UITableViewController {
    
    typealias ExpandableRemainder = (remainder :Remainder , expanded :Bool)
    
    var remainders : Dictionary<RemainderCategory,Array<ExpandableRemainder>> = [:]
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        setupTableView()
        setupNavigationITem()
        setupTheme()
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(RemainderTableViewCell.self, forCellReuseIdentifier: RemainderTableViewCell.cellID)
    }
    
    fileprivate func setupNavigationITem() {
        navigationItem.title = "Remaindzzers"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRemainder))
    }
    
    @objc func addRemainder() {
        // testing
        let remainder = Remainder(title: "Stuff for someone", description: "description of what the remainder for", coordinates: Coordinates(latitude: 0, longitude: 0), timestamp: NSDate().timeIntervalSince1970, category: .custom)
        self.remainders[.custom] = [(remainder , false)]
        self.tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK:- TableView Delegation

extension RemainderTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return remainders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(remainders.keys)[section]
        return remainders[key]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemainderTableViewCell.cellID, for: indexPath) as! RemainderTableViewCell
        let category = Array(remainders.keys)[indexPath.section]
        let expandableRemainder = self.remainders[category]![indexPath.row]

        cell.textLabel?.text = expandableRemainder.remainder.title
        
        // set up date formating
        
        let date = NSDate(timeIntervalSince1970: expandableRemainder.remainder.timestamp)
        
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: date as Date)
        let date2 = calendar.startOfDay(for: Date())

        let dateFormatter = DateFormatter()
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        if let days = components.day , days > 0{
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
        }else {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
        }
        
        cell.timestampLabel.text = dateFormatter.string(from: date as Date)
        
        if expandableRemainder.expanded , let description  = expandableRemainder.remainder.description{
            cell.detailTextLabel?.text = description
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
        }else {
            cell.detailTextLabel?.text = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(remainders.keys)[indexPath.section]
        remainders[key]![indexPath.row].expanded = !(remainders[key]![indexPath.row].expanded)
        tableView.reloadData()
    }
    
     
}

//MARK:- Themed

extension RemainderTableViewController : Themed {
    
    func applyTheme(_ theme: Theme) {
        tableView.backgroundColor = theme.backgroundColor
    }
}
