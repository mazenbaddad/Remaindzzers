//
//  RemainderCategory.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/1/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import Foundation
import UIKit

enum RemainderCategory: Int16 {
    
    
    case pharmacy = 0
    case grocery = 1
    case bakery = 2
    case butchery = 3
    case plantShop = 4
    case custom = 5
    
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
        case 4:
            return .plantShop
        default:
            return .custom
        }
    }
    
    var image : UIImage? {
        switch self {
        case .pharmacy :
            return UIImage(named:"pharmacy")
        case .grocery:
            return UIImage(named:"grocery")
        case .bakery:
            return UIImage(named:"bakery")
        case .butchery :
            return UIImage(named:"butchery")
        case .plantShop:
            return UIImage(named:"flower")
        default:
            return UIImage(named:"location")
        }
    }
}
