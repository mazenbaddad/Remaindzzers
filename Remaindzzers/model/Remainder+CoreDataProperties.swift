//
//  Remainder+CoreDataProperties.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/5/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//
//

import Foundation
import CoreData


extension Remainder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remainder> {
        return NSFetchRequest<Remainder>(entityName: "Remainder")
    }

    @NSManaged public var title: String?
    @NSManaged public var remainderDescription: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var category: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
