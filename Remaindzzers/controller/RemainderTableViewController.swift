//
//  RemainderTableViewController.swift
//  Remaindzzers
//
//  Created by mazen baddad on 10/31/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit
import CoreData


class RemainderTableViewController : UITableViewController {
    
    typealias ExpandableRemainder = (remainder :Remainder , expanded :Bool)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var remainders : Dictionary<RemainderCategory.RawValue,Array<ExpandableRemainder>> = [:]
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        setupTableView()
        setupNavigationITem()
        setupTheme()
        fetchRemainders()
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(RemainderTableViewCell.self, forCellReuseIdentifier: RemainderTableViewCell.cellID)
        tableView.register(CategoryTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    fileprivate func setupNavigationITem() {
        navigationItem.title = "Remaindzzers"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRemainder))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "location_nav"), style: .done, target: self, action: #selector(mapTapped))
    }
    
    @objc func addRemainder() {
        let remainderAlertView = RemainderAlertView()
        remainderAlertView.delegate = self
        remainderAlertView.present()
    }
    
    @objc func mapTapped() {
        let mapViewController = MapViewController()
        mapViewController.delegate = self
        present(mapViewController, animated: true)
    }
    
    func fetchRemainders() {
        self.remainders.removeAll()
        do {
            let remainders = try self.context.fetch(Remainder.fetchRequest()) as [Remainder]
            for remainder in remainders {
                append(remainder: remainder)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch {
            print(error)
        }
    }
    
    func append(remainder : Remainder) {
        if self.remainders[remainder.category] != nil {
            self.remainders[remainder.category]?.append((remainder,false))
        }else {
            self.remainders[remainder.category] = [(remainder,false)]
        }
    }
    
    func formatedDateString(from timestamp : Double) -> String {
        let date = NSDate(timeIntervalSince1970: timestamp)
        
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
        return dateFormatter.string(from: date as Date)
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
        cell.timestampLabel.text = self.formatedDateString(from : expandableRemainder.remainder.timestamp)
        
        if expandableRemainder.expanded , let description  = expandableRemainder.remainder.remainderDescription{
            cell.detailTextLabel?.text = description
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
        }else {
            cell.detailTextLabel?.text = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, complitionHandler) in
            guard let self = self else {return}
            print(indexPath.row)
            let category = Array(self.remainders.keys)[indexPath.section]
            let expandableRemainder = self.remainders[category]![indexPath.row]
            
            
            self.context.delete(expandableRemainder.remainder)
            do {
                try self.context.save()
                self.remainders[category]?.remove(at: indexPath.row)
                if self.remainders[category]!.count < 1 {
                    self.remainders[category] = nil
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch {
                print(error)
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CategoryTableHeaderView
        let category = Array(remainders.keys)[section]
        let image = RemainderCategory.category(from: category).image
        view.catagoryImageView.image = image
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = themeManager.currentTheme.secondaryBackgroundColor
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(remainders.keys)[indexPath.section]
        remainders[key]![indexPath.row].expanded = !(remainders[key]![indexPath.row].expanded)
        tableView.reloadData()
    }
    
     
}

//MARK:- AlertView Delegate

extension RemainderTableViewController : AlertViewDelegate {
    
    func alertView(_ alertView: AlertView, didAdd alertInfo: Dictionary<String, Any>) {
        let alertView = alertView as! RemainderAlertView
        if let title = alertInfo[alertView.titleAlertKey] as? String,
            let catagory = alertInfo[alertView.categoryAlertKey] as? Int16 ,
            let timestamp = alertInfo[alertView.timestampAlertKey] as? Double ,
            let latitude = alertInfo[alertView.latitudeAlertKey] as? Double ,
            let longitude = alertInfo[alertView.longitudeAlertKey] as? Double{
            
            
            let description = alertInfo[alertView.descriptionAlertKey] as? String
            let remainder = Remainder(context: self.context)
            remainder.title = title
            remainder.remainderDescription = description
            remainder.category = catagory
            remainder.timestamp = timestamp
            remainder.latitude = latitude
            remainder.longitude = longitude
            print("remainder , latitiude:\(latitude) , longitude:\(longitude)")
            do {
                try self.context.save()
                self.append(remainder: remainder)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch {
                print(error)
            }
        }
        alertView.removeFromSuperview()
    }
    
}

extension RemainderTableViewController : MapViewControllerDelegate {
    func mapViewControllerDidUpdateRemainders() {
        self.fetchRemainders()
    }
}

//MARK:- Themed

extension RemainderTableViewController : Themed {
    
    func applyTheme(_ theme: Theme) {
        tableView.backgroundColor = theme.backgroundColor
    }
}
