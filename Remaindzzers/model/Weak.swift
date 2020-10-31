//
//  Weak.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/19/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import Foundation

/// A box that allows us to weakly hold on to an object
struct Weak<Object:AnyObject> {
    weak var value: Object?
}
