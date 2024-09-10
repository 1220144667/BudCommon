//
//  StringExtension.swift
//  BudMall
//
//  Created by 洪陪 on 2024/3/13.
//

import Foundation
import CommonCrypto

extension String {
    
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
