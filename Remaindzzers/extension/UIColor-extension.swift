//
//  UIColor-extension.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/19/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit


extension UIColor {
    
    var components : (red : CGFloat? , green : CGFloat? , blue : CGFloat? , alpha : CGFloat?) {
        get {
            let components = self.cgColor.components
            if components?.count == 4 {
                let red = components![0] * 255.0
                let green = components![1] * 255.0
                let blue = components![2] * 255.0
                let alpha = components![3]
                return (red, green , blue, alpha)
            }
            return (nil , nil ,nil ,nil)
        }
    }
    
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF
            ,green: (hex >> 8) & 0xFF
            ,blue: hex & 0xFF
            ,a: 1)
    }
}
