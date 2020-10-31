//
//  UIView-extension.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/19/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

extension UIView {
    
    
    /** Set constraints to UIView (Leading,Top,Trailing,Bottom).
    *   Requires at least Leading and Top anchors.
    *   Make the anchors (nil) make the Constant the height or the width constrains of the View ((Top,Bottom:Height) , (Leading,Trailing:Width)).
    */
    func setConstraints(  _ leading : NSLayoutAnchor<NSLayoutXAxisAnchor>? , _ leadingConstant : CGFloat
                        , _ top : NSLayoutAnchor<NSLayoutYAxisAnchor>? , _ topConstant : CGFloat
                        , _ trailing : NSLayoutAnchor<NSLayoutXAxisAnchor>?  = nil, _ trailingConstant : CGFloat? = nil
                        , _ bottom : NSLayoutAnchor<NSLayoutYAxisAnchor>?  = nil,_ bottomConstant : CGFloat? = nil  ) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leading != nil ? self.leadingAnchor.constraint(equalTo: leading! , constant: leadingConstant) : (self.widthAnchor.constraint(equalToConstant: leadingConstant)),
            top != nil ? self.topAnchor.constraint(equalTo: top! , constant: topConstant) : (self.heightAnchor.constraint(equalToConstant: topConstant))
            ])
        
        if let trailingConstant = trailingConstant {
            trailing != nil ?
                self.trailingAnchor.constraint(equalTo: trailing!  , constant: trailingConstant).isActive = true
                :(self.widthAnchor.constraint(equalToConstant: trailingConstant).isActive = true)
        }
        if let bottomConstant = bottomConstant {
            bottom != nil ?
                self.bottomAnchor.constraint(equalTo: bottom! , constant: bottomConstant).isActive = true
                :(self.heightAnchor.constraint(equalToConstant: bottomConstant).isActive = true)
        }
    }
}

