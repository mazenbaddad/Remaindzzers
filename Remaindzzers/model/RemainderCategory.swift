//
//  RemainderCategory.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/1/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import Foundation

enum RemainderCategory: Int16 {
    case custom = 0
    static func caregory(from rawValue : Int16) -> RemainderCategory {
        switch rawValue {
        case 0:
            return .custom
        default:
            return .custom
        }
    }
}
