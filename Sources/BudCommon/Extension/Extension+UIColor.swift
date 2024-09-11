//
//  Extension+UIColor.swift
//  iMarket
//
//  Created by 洪陪 on 2023/8/30.
//

import Foundation
import UIKit

public extension UIColor {
    // 主文字颜色
    class var textColor: UIColor {
        return UIColor(red: 57 / 255.0, green: 57 / 255.0, blue: 57 / 255.0, alpha: 1)
    }

    //
    class var subTextColor: UIColor {
        UIColor(red: 135 / 255.0, green: 135 / 255.0, blue: 135 / 255.0, alpha: 1)
    }

    class var greyTextColor: UIColor {
        UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1)
    }

    class var themColor: UIColor {
        return UIColor(red: 128 / 255.0, green: 1 / 255.0, blue: 254 / 255.0, alpha: 1)
    }

    // 边框颜色
    class var borderColor: UIColor {
        return UIColor(red: 244.0 / 255, green: 244.0 / 255, blue: 244.0 / 255, alpha: 1)
    }

    // 分割线颜色
    class var lineViewColor: UIColor {
        return UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1)
    }

    // 控件填充颜色
    class var fillBoxColor: UIColor {
        return UIColor(red: 249 / 255, green: 250 / 255, blue: 251 / 255, alpha: 1)
    }

    class var B5BCCE: UIColor {
        return UIColor(red: 181.0 / 255, green: 188.0 / 255, blue: 206.0 / 255, alpha: 1)
    }

    class var baseColor: UIColor {
        return UIColor(red: 250 / 255.0, green: 250 / 255.0, blue: 250 / 255.0, alpha: 1)
    }

    class var defaultColor: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }

    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        UIColor(r, g, b)
    }
}

public extension UIColor {
    // 使用rgba方式生成自定义颜色
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, a: CGFloat = 1.0) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }

    // 16进制生成自定义颜色
    class func colorToHex(_ hex: String, _ alpha: CGFloat = 1.0) -> UIColor {
        var colorString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if colorString.count < 6 {
            return UIColor.clear
        }

        if colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }

        if colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }

        if colorString.count < 6 {
            return UIColor.clear
        }

        var rang = NSRange()
        rang.location = 0
        rang.length = 2

        let rString = (colorString as NSString).substring(with: rang)
        rang.location = 2
        let gString = (colorString as NSString).substring(with: rang)
        rang.location = 4
        let bString = (colorString as NSString).substring(with: rang)

        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0

        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)

        return UIColor(CGFloat(r), CGFloat(g), CGFloat(b), a: alpha)
    }

    // 返回随机颜色
    class var randomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
