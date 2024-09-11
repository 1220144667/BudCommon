//
//  StringExtension.swift
//  BudMall
//
//  Created by 洪陪 on 2024/3/13.
//

import Foundation
import CommonCrypto
import SwifterSwift

public extension String {
    
    /// 添加国际化调佣
    /// - Returns: 返回国际化内容
    func localized() -> String {
      return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
    //获取时间戳:13位，毫秒级
    static func millisecondTimerstamp() -> String {
        let timeStamp = self.millisecondTimerstampToInt()
        return "\(Int(timeStamp))"
    }
    
    //获取时间戳:13位，毫秒级
    static func millisecondTimerstampToInt() -> Int {
        let time = Date().timeIntervalSince1970
        let timeStamp = TimeInterval(time) * 1000
        return Int(timeStamp)
    }
    
    /// 密码验证
    /// - Returns: 返回结果：密码应该大于8位和小于24位、并且包含大写字母、小写字母、数字和特殊符号种的3种
    func vaild() -> Bool {
        if (self.count < 8) || (self.count > 24) { return false }
        //数字
        let REG_NUMBER = ".*\\d+.*"
        //小写字母
        let REG_UPPERCASE = ".*[A-Z]+.*"
        //大写字母
        let REG_LOWERCASE = ".*[a-z]+.*"
        //特殊符号
        let REG_SYMBOL = ".*[~!@#$%^&*()_+|<>,.?/:;'\\[\\]{}\"]+.*"
        
        var i = 0
        
        let pred1 = NSPredicate(format: "SELF MATCHES %@", REG_NUMBER)
        if pred1.evaluate(with: self) {
            i += 1
        }
        let pred2 = NSPredicate(format: "SELF MATCHES %@", REG_UPPERCASE)
        if pred2.evaluate(with: self) {
            i += 1
        }
        
        let pred3 = NSPredicate(format: "SELF MATCHES %@", REG_LOWERCASE)
        if pred3.evaluate(with: self) {
            i += 1
        }
        
        let pred4 = NSPredicate(format: "SELF MATCHES %@", REG_SYMBOL)
        if pred4.evaluate(with: self) {
            i += 1
        }
        return !(i < 3)
    }
    
    
    /// 获取随机字符串
    /// - Parameter length: 长度 例：如果需要8位随机字符串 则传入8
    /// - Returns: 返回获取到的随机字符串
    static func randomAlphanumericString(length: Int) -> String  {
        enum Statics {
            static let scalars = [UnicodeScalar("a").value...UnicodeScalar("z").value,
                                  UnicodeScalar("A").value...UnicodeScalar("Z").value,
                                  UnicodeScalar("0").value...UnicodeScalar("9").value].joined()

            static let characters = scalars.map { Character(UnicodeScalar($0)!) }
        }

        let result = (0..<length).map { _ in Statics.characters.randomElement()! }
        return String(result)
    }
    
    /// sha256加密
    var sha256: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

public extension String {
    /// 银行卡格式化
    var formatBankNumber: String {
        var number = self
        let idx = 4
        if count >= idx {
            if number.count == idx {
                number = "****"
            } else {
                let textAsNSString = self as NSString
                let range = NSMakeRange(0, textAsNSString.length - idx)

                var characters = ""
                for _ in 1 ... range.length {
                    characters.append("*")
                }

                number = textAsNSString.replacingCharacters(in: range, with: characters)
            }
        }

        return number
    }

    /// 手机号脱敏
    var formatPhoneNumber: String {
        var number = self
        let idx = 6
        if count > idx {
            let textAsNSString = self as NSString
            let range = NSMakeRange(0, textAsNSString.length - idx)

            var characters = ""
            for _ in 1 ... range.length {
                characters.append("*")
            }

            number = textAsNSString.replacingCharacters(in: range, with: characters)
        }

        return number
    }

    /// 货币格式化
    var numberFormatterByDecimal: String {
        guard let value = double() else {
            return ""
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        guard let result = formatter.string(from: NSNumber(value: value)) else {
            return ""
        }

        return result
    }

    // MARK: (传入汉字字符串, 返回大写拼音首字母)

    var firstLetterFromString: String {
        guard count != 0 else {
            return ""
        }
        // 注意,这里一定要转换成可变字符串
        let mutableString = NSMutableString(string: self)
        // 将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(用此方法大大提高遍历的速度)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        // 将拼音首字母装换成大写
        let strPinYin = polyphoneStringHandle(nameString: self, pinyinString: pinyinString).uppercased()
        // 截取大写首字母
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        // 判断姓名首位是否为大写字母
        let regexA = "^[A-Z]$"
        let predA = NSPredicate(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
        /// 多音字处理
        func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
            if nameString.hasPrefix("长") { return "chang" }
            if nameString.hasPrefix("沈") { return "shen" }
            if nameString.hasPrefix("厦") { return "xia" }
            if nameString.hasPrefix("地") { return "di" }
            if nameString.hasPrefix("重") { return "chong" }

            return pinyinString
        }
    }

    var complexityMatches: Bool {
        // 1.全部包含：大写、小写、数字、特殊字符；
        let regex1 = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\\W_])^.{6,}$"
        // 2.无大写：小写、数字、特殊字符；
        let regex2 = "(?=.*[a-z])(?=.*[0-9])(?=.*[\\W_])^.{6,}$"
        // 3.无小写：大写、数字、特殊字符；
        let regex3 = "(?=.*[A-Z])(?=.*[0-9])(?=.*[\\W_])^.{6,}$"
        // 4.无数字：大写、小写、特殊字符；
        let regex4 = "(?=.*[A-Z])(?=.*[a-z])(?=.*[\\W_])^.{6,}$"
        // 5.无特殊字符：大写、小写、数字；
        let regex5 = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])^.{6,}$"

        let regex = "\(regex1)|\(regex2)|\(regex3)|\(regex4)|\(regex5)"

        return matches(pattern: regex)
    }
}
