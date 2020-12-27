//
//  RemainderView.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/2/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit
import CoreLocation

class RemainderAlertView : AlertView {
    
    let latitudeAlertKey : String = "latitudeAlertKey"
    let longitudeAlertKey : String = "longitudeAlertKey"
    let timestampAlertKey : String = "dateAlertKey"
    let categoryAlertKey: String = "categoryAlertKey"
    
    
    typealias Category = (name : String, coordinates : CLLocationCoordinate2D)
    var categories : Array<Category> = []
    var selectedCategory : Int = 0
    
    var categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Pick a Cetagory"
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        return label
    }()
    
    var categoryPickerView : UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        topTitleLabel.text = "New remainder"
        titleLabel.text = "Remainder title"
        descriptionLabel.text = "Remainder description"
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        self.containerView.addSubview(categoryLabel)
        self.containerView.addSubview(categoryPickerView)
        categoryLabel.setConstraints(containerView.leadingAnchor, 10, descriptionTextView.bottomAnchor, 10)
        categoryPickerView.setConstraints(containerView.leadingAnchor, 10, categoryLabel.bottomAnchor, 5 , containerView.trailingAnchor , -10 , nil , 70)
        
        setupCategories()
    }
    
    func setupCategories() {
        let zeroCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.categories = [("Pharmacy" , zeroCoordinates),("Grocery", zeroCoordinates) ,("Bakery" , zeroCoordinates) ,("Butchery" , zeroCoordinates) , ("Plant shop" , zeroCoordinates)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let customCategories = try context.fetch(CustomCategory.fetchRequest()) as [CustomCategory]
            for category in customCategories where category.title != nil{
                self.categories.append((category.title! , CLLocationCoordinate2D(latitude: category.latitude, longitude: category.longitude)))
            }
        }catch {
            print(error)
        }
        categoryPickerView.reloadAllComponents()
    }
    
    override func containerViewPerfectHeight() -> CGFloat {
        let categoryLabelHeight = categoryLabel.text!.size(withMaximumWidth: containerView.frame.width, font: categoryLabel.font).height
        let pickerViewHeight : CGFloat = 70
        let extraSpaces : CGFloat = 10
        return super.containerViewPerfectHeight() + categoryLabelHeight + pickerViewHeight + extraSpaces
    }
    
    @objc override func didAdd() {
        let title = titleTextField.text ?? ""
        let validTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !validTitle.isEmpty {
            let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            let validDescription : String? = description.isEmpty ? nil : description
            var alertInfo : Dictionary<String , Any> = [:]
            alertInfo[titleAlertKey] = title
            alertInfo[descriptionAlertKey] = validDescription
            alertInfo[latitudeAlertKey] = self.categories[self.selectedCategory].coordinates.latitude
            alertInfo[longitudeAlertKey] = self.categories[self.selectedCategory].coordinates.longitude
            alertInfo[timestampAlertKey] = NSDate().timeIntervalSince1970
            alertInfo[categoryAlertKey] = Int16(self.selectedCategory)
            self.delegate?.alertView(self, didAdd: alertInfo)
        }else {
            shakeView(titleLabel)
        }
    }
    
    override func applyTheme(_ theme: Theme) {
        super.applyTheme(theme)
        self.categoryLabel.textColor = theme.labelColor
        self.categoryPickerView.tintColor = theme.labelColor
    }
    
}

//MARK:- PickerView Delegate

extension RemainderAlertView : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = row
    }
    
}
