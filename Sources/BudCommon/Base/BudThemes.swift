//
//  BudThemes.swift
//  BudChat
//
//  Created by 洪陪 on 2024/3/11.
//  Copyright © 2024 BudChat LLC. All rights reserved.
//

import Foundation
import UIKit
import SwiftTheme

private let lastThemeIndexKey = "lastedThemeIndex"
private let defaults = UserDefaults.standard

enum BudThemes: Int {
    case day = 0
    case night = 1

    static func current() -> BudThemes {
        let index = defaults.integer(forKey: lastThemeIndexKey)
        let theme = BudThemes(rawValue: index) ?? .day
        return theme
    }

    // MARK: - Switch Theme

    static func switchTo(theme: BudThemes) {
        let index = theme.rawValue
        ThemeManager.setTheme(index: index)
        // 保存
        defaults.set(index, forKey: lastThemeIndexKey)
    }

    // MARK: - Switch Night

    static func switchNight(isToNight: Bool) {
        if isToNight {
            switchTo(theme: .night)
        } else {
            switchTo(theme: .day)
        }
    }

    // MARK: - Save & Restore

    static func restoreLastTheme() {
        let row = defaults.integer(forKey: lastThemeIndexKey)
        switchTo(theme: BudThemes(rawValue: row) ?? .day)
        // 设置navigation
        UIApplication.shared.theme_setStatusBarStyle([.lightContent, .default], animated: true)
        let navigationBar = UINavigationBar.appearance()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        navigationBar.theme_tintColor = BudColor.textColor
        navigationBar.theme_barTintColor = BudColor.navigationColor
        navigationBar.setBackgroundImage(nil, for: .default)
    }

    static func saveLastTheme() {
        let index = ThemeManager.currentThemeIndex
        defaults.set(index, forKey: lastThemeIndexKey)
    }
}

enum BudColor {
    static let backgroundColor: ThemeColorPicker = ["#FAFAFA", "#121212"]
    static let blockColor: ThemeColorPicker = ["#FAFAFA", "#292929"]
    static let subBackgroundColor: ThemeColorPicker = ["#FFFFFF", "#292929"]
    static let navigationColor: ThemeColorPicker = ["#FFFFFF", "#121212"]
    static let textColor: ThemeColorPicker = ["#393939", "#FFFFFF"]
    static let subTextColor: ThemeColorPicker = ["#5F524C", "#FFFFFF"]
    static let separatorColor: ThemeColorPicker = ["#EEEEEE", "#37313E"]
    static let greyTextColor: ThemeColorPicker = ["#999999", "#FAFAFA"]
    static let bankCardColor: ThemeColorPicker = ["#EEEEEE", "#292929"]
}
