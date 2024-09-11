//
//  DecryptProvider.swift
//  BudChat
//
//  Created by 文伍 on 2024/9/5.
//

import Foundation
import Kit

class DecryptProvider {
    // ----------- 模块 -----------
    enum SignType {
        case pay // 支付
        case kyc // 人脸
        case moment // 朋友圈
        case aws // 亚马逊
    }

    // ----------- 解密Key -----------
    private func decodeKey(bud: String, date: String?, type: SignType) -> String? {
        guard let time = date else { return nil }
        let timestamp = covertLocaleTimerstamp(time) ?? 0
        let bizType = getZipCode(type)
        let key = KitKeyDecode(bud, Int64(timestamp), bizType)
        return key
    }

    // ----------- 时间戳转换 -----------
    func covertLocaleTimerstamp(_ time: String?) -> Int? {
        guard let string = time else { return nil }
        let fmatter = DateFormatter()
        fmatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZ"
        fmatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = fmatter.date(from: string) else { return nil }
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval * 1000)
    }

    // ----------- 支付私钥解密 -----------
    func decryptPayPrivateKey(bud: String, appPrivate: String, date: String?) -> String? {
        if let key = decodeKey(bud: bud, date: date, type: .pay) {
            return String.aesDecrypt(content: appPrivate, key: key)
        }
        return nil
    }

    // ----------- 支付公钥解密 -----------
    func decryptPayPublicKey(bud: String, appPublic: String, date: String?) -> String? {
        if let key = decodeKey(bud: bud, date: date, type: .pay) {
            return String.aesDecrypt(content: appPublic, key: key)
        }
        return nil
    }
}

extension DecryptProvider {
    // ----------- 获取解密参数 -----------
    func getZipCode(_ type: SignType) -> Int {
        switch type {
        case .pay:
            return Int(KitPAY)
        case .kyc:
            return Int(KitKYC)
        case .moment:
            return Int(KitMOMENT)
        case .aws:
            return Int(KitAWS)
        }
    }
}
