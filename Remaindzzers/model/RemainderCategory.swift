//
//  RemainderCategory.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/1/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum RemainderCategory: Int16 {
    
    case pharmacy = 0
    case grocery = 1
    case bakery = 2
    case butchery = 3
    case plantShop = 4
    case custom = 5
    
    static func category(from rawValue : Int16) -> RemainderCategory {
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
    
    static var locations : [(category : RemainderCategory , coordinates :CLLocationCoordinate2D)] {
        return [(.pharmacy , CLLocationCoordinate2D(latitude: 32.000000000, longitude: 32.000000000)) ,
                (.pharmacy , CLLocationCoordinate2D(latitude: 33.000000000, longitude: 33.000000000)) ,
                (.grocery , CLLocationCoordinate2D(latitude: 32.111111111, longitude: 32.111111111)) ,
                (.grocery , CLLocationCoordinate2D(latitude: 33.111111111, longitude: 33.111111111)) ,
                (.bakery , CLLocationCoordinate2D(latitude: 32.222222222, longitude: 32.222222222)) ,
                (.bakery , CLLocationCoordinate2D(latitude: 33.222222222, longitude: 33.222222222)) ,
                (.butchery , CLLocationCoordinate2D(latitude: 32.333333333, longitude: 32.333333333)) ,
                (.butchery , CLLocationCoordinate2D(latitude: 33.333333333, longitude: 33.333333333)) ,
                (.plantShop , CLLocationCoordinate2D(latitude: 32.444444444, longitude: 32.444444444)) ,
                (.plantShop , CLLocationCoordinate2D(latitude: 33.444444444, longitude: 33.444444444)) ,]
    }
}
