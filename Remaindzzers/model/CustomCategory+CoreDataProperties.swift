//
//  CustomCategory+CoreDataProperties.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/7/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//
//

import Foundation
import CoreData


extension CustomCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomCategory> {
        return NSFetchRequest<CustomCategory>(entityName: "CustomCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
