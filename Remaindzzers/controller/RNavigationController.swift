//
//  AwkwardNavigationController.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/20/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

/// themed navigation controller
class RNavigationController : UINavigationController {
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return super.preferredStatusBarStyle
        }
        return themedStatusBarStyle ?? super.preferredStatusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            return
        }
        setupTheme()
    }
    
}

//MARK:- Themed

extension RNavigationController: Themed {
    
    func applyTheme(_ theme: Theme) {
        
        self.themedStatusBarStyle = theme.statusBarStyle
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.navigationBar.barTintColor = theme.barBackgroundColor
        self.navigationBar.tintColor = theme.appTintColor
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.labelColor
        ]
        self.navigationBar.layoutIfNeeded()
    }
}
