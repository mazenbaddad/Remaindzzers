//
//  Themed.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/19/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

protocol Themed {
    var themeManager:ThemeManager {get}
    func applyTheme(_ theme:Theme)
}

extension Themed where Self:AnyObject {
    
    var themeManager:ThemeManager { return ThemeManager.shared }
    
    /// apply the current theme and subscibe to any changes
    func setupTheme() {
        applyTheme(themeManager.currentTheme)
        if #available(iOS 13, *) {
            return
        }
        themeManager.subscribeToChanges(self) { [weak self] theme in
            self?.applyTheme(theme)
        }
    }
}
