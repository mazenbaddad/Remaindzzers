//
//  ThemeManager.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/19/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

class ThemeManager{
    
    private typealias Subscription = (object: Weak<AnyObject>, handler: (Theme) -> Void)
    
    static let shared: ThemeManager = .init()
    private let userDefaultThemeKey : String = "adeeb.userDefaultTheme.key"
    private let availableThemes: [Theme] = [.light, .dark]
    
    private var subscriptions: Array<Subscription> = []
    private var nextThemeIndex : Int {
        get {
            return isDark ? 0 : 1
        }
    }
    private var _currentTheme : Theme {
        didSet {
            for  (object , handler) in self.subscriptions where object.value != nil{
                handler(self._currentTheme)
            }
        }
    }
    var isDark : Bool {
        get {
            if #available(iOS 13, *) {
                return UITraitCollection.current.userInterfaceStyle == .dark
            }
            return _currentTheme == Theme.dark
        }
    }

    var currentTheme: Theme {
        if #available(iOS 13, *) {
            let barBackgroundColor = isDark ? UIColor.black : UIColor.white
            return Theme(statusBarStyle: .default, barBackgroundColor: barBackgroundColor, appTintColor: .systemBlue, backgroundColor: .systemGroupedBackground, secondaryBackgroundColor: .secondarySystemGroupedBackground, labelColor: .label, secondaryLabelColor: .secondaryLabel, tertiaryLabelColor: .tertiaryLabel)
        }
        return _currentTheme
    }
    
    init() {
        var index = UserDefaults.standard.integer(forKey: userDefaultThemeKey)
        index = index != 0 ? 1 : 0
        _currentTheme = availableThemes[index]
    }
    
    
    /// subscribe to changes in the current theme
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (Theme) -> Void) {
        subscriptions.append((Weak(value: object), handler))
        self.cleanupSubscriptions()
    }
    
    /// change to next theme
    func nextTheme() {
        let newTheme = availableThemes[nextThemeIndex]
        setThemeToUserDefault()
        let window = UIApplication.shared.delegate!.window!!
        UIView.transition(with: window,duration: 0.3,options: [],animations: {
            self._currentTheme = newTheme
        })
    }
    
    /// add theme value to `UserDefault`
    private func setThemeToUserDefault() {
        UserDefaults.standard.set(nextThemeIndex, forKey: userDefaultThemeKey)
    }
    
    /// remove deallocated objects from `subscriptions`
    private func cleanupSubscriptions() {
        subscriptions = subscriptions.filter { $0.object.value != nil }
    }
}

