//
//  RequestExpiresable.swift
//  iAntique
//
//  Created by 文伍 on 2024/6/4.
//  Token过期处理

import Foundation
import Moya
import PromiseKit
import Network
import CryptoSwift

// MARK: - ---------- token过期时间判断 -----------

public protocol RequestExpiresable {
    func refreshToken() -> Promise<AuthInfo?>

    func decideExpires() -> Bool
}

public extension RequestExpiresable {
    func refreshToken() -> Promise<AuthInfo?> {
        return Promise { seal in
            firstly {
                // ----------- 获取refresh数据 -----------
                let api = UserApi.getRefreshtoken
                return Bud.request(path: api, type: RefreshTokenData.self)
            }.then { data in
                // ----------- 刷新token -----------
                let api = UserApi.login(self.getAuthParams(data: data), .password)
                return Bud.request(path: api, type: AuthInfo.self)
            }.done { auth in
                seal.fulfill(auth)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    /// 包装refreshToken接口的参数
    /// - Parameter data: getRefreshTokenParam接口返回的数据
    /// "clientId": "BudKoc",
    /// "originSecret": "5/L0bFOC5PvhlCljZQeThZE3bko5a0C3QWNOpjyI3zY=",
    /// "key": "5c684314-340d-49f9-9b65-f2c474b1e0a4"
    /// - Returns: 包装参数
    func getAuthParams(data: RefreshTokenData?) -> [String: Any] {
        // ----------- key -----------
        let key = data?.key ?? ""

        // ----------- clientId -----------
        let clientId = data?.clientId ?? ""

        // ----------- 需要加密的内容 -----------
        let content = data?.originSecret ?? ""

        // ----------- 加密的key = clientId + key 截取前16位（截取内部已实现） -----------
        let encryptCode = String.aesEncrypt(content: content, key: clientId + key)

        let token = UserDefaults.standard.string(forKey: refresh_token_key)

        // ----------- 参数包装 -----------
        var params: [String: Any] = [:]
        params["grant_type"] = "refresh_token"
        params["refresh_token"] = token
        params["client_id"] = clientId
        params["client_secret"] = encryptCode
        return params
    }

    func decideExpires() -> Bool {
        // ----------- 通过获取到缓存的user信息 -----------
        guard let info = UserManager.shared.user else { return false }

        // ----------- 获取到过期时间（从产生token开始计算、到多久过期 单位：秒） -----------
        guard let expires_in = info.auth?.expires_in else { return false }

        // ----------- token更新时间 -----------
        guard let update_at = info.auth?.update_at else { return false }

        // ----------- 获取当前时间戳（单位：秒） -----------
        let newTime = Date.nowTimeStamp()

        // ----------- 获取token更新的时候产生的时间戳（单位：秒） -----------
        let oldTime = Date.getTimeStamp(with: update_at)

        // ----------- 和当前的时间差(取绝对值) -----------
        let difference = abs(newTime - oldTime)
        // ----------- (当前时间 - token的更新时间) 如果大于过期时间、已过期、需要进行token刷新逻辑 -----------
        // ----------- 一天 = 24（小时）= 1440（分钟）= 86400（秒） -----------
        let expires = difference > expires_in

        // ----------- 如果token过期，清理掉auth信息 -----------
        if expires {
            UserManager.shared.clearUser()
        }
        return expires
    }
}

// MARK: - ---------- AES加解密 -----------

public extension String {
    // ----------- AES加密 -----------
    static func aesEncrypt(content: String, key: String) -> String? {
        do {
            if key.count < 16 { return nil }

            // ----------- 截取key的前16位作为加密的key -----------
            let key = String(key.prefix(16))

            // ----------- AES加密 -----------
            let aes = try AES(key: key.bytes, blockMode: ECB(), padding: .pkcs7)
            // 加密
            let ciphertext = try aes.encrypt(content.bytes)

            // ----------- 转data -----------
            let cryptData = Data(ciphertext)

            // ----------- base64编码 -----------
            let rusult = cryptData.base64EncodedString()

            return rusult
        } catch {
            return nil
        }
    }
    
    // ----------- AES解密 -----------
    static func aesDecrypt(content: String, key: String) -> String? {
        do {
            if key.count < 16 { return nil }
            let iv = String(key.prefix(16))
            let data = Array(base64: content)

            let aes = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs5)

            let ciphertext = try aes.decrypt(data)
            let myData = Data(ciphertext)

            let rusult = myData.base64EncodedString()

            return rusult
        } catch {
            return nil
        }
    }
}
