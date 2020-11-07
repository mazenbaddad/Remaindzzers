//
//  RemainderCategory.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/1/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import Foundation

enum RemainderCategory: Int16 {
    
    
    case pharmacy = 0
    case grocery = 1
    case bakery = 2
    case butchery = 3
    case freshStore = 4
    case planetShop = 5
    case custom = 6
    
    static func caregory(from rawValue : Int16) -> RemainderCategory {
        switch rawValue {
        case 0 :
            return .pharmacy
        case 1:
            return .grocery
        case 2:
            return .bakery
        case 3 :
            return . butchery
        case 4 :
            return .freshStore
        case 5:
            return .planetShop
        default:
            return .custom
        }
    }
}
