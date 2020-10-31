//
//  Theme.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/19/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

struct Theme : Equatable {
    
    var statusBarStyle: UIStatusBarStyle
    
    var barBackgroundColor: UIColor
    
    var appTintColor: UIColor

    var backgroundColor: UIColor
    
    var secondaryBackgroundColor : UIColor
    
    /// for texts this should be dark
    var labelColor : UIColor
    /// for texts this should be lighter then `titleColor`
    var secondaryLabelColor: UIColor
    /// for placeholder
    var tertiaryLabelColor:UIColor
}

extension Theme {
    static var light : Theme {
        return Theme(statusBarStyle: .default
            , barBackgroundColor: UIColor(hex: 0xFFFFFF)
            , appTintColor: UIColor(hex: 0x007aff)
            , backgroundColor: UIColor(hex: 0xf2f2f7)
            , secondaryBackgroundColor: UIColor(hex: 0xffffff)
            , labelColor: UIColor(hex: 0x000000)
            , secondaryLabelColor: UIColor(hex: 0x3c3c43).withAlphaComponent(0.6)
            , tertiaryLabelColor: UIColor(hex: 0x3c3c43).withAlphaComponent(0.3)
        )
    }
    static var dark : Theme {
        return Theme(statusBarStyle: .lightContent
            , barBackgroundColor: UIColor(hex: 0x000000)
            , appTintColor: UIColor(hex: 0x0a84ff)
            , backgroundColor: UIColor(hex: 0x000000)
            , secondaryBackgroundColor: UIColor(hex: 0x1c1c1e)
            , labelColor: UIColor(hex: 0xFFFFFF)
            , secondaryLabelColor: UIColor(hex: 0xebebf5).withAlphaComponent(0.6)
            , tertiaryLabelColor: UIColor(hex: 0xebebf5).withAlphaComponent(0.3)
        )
    }
}

