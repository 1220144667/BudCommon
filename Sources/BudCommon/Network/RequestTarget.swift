//
//  RequestTarget.swift
//  iMarket
//
//  Created by 洪陪 on 2023/8/31.
//

import Alamofire
import Foundation
import Moya
import PromiseKit
import SwiftyRSA
import CryptoSwift

// MARK: - ---------- 构造请求类 -----------

extension RequestTarget {
    static func create(_ api: RequestApi, encoding: ParameterEncoding) -> Self {
        return Self(api, encoding: encoding)
    }
}

// MARK: - ---------- 网络请求类实现 -----------

struct RequestTarget: TargetType {
    
    private var api: RequestApi

    // 初始化
    init(_ api: RequestApi, encoding: ParameterEncoding) {
        self.api = api
        self.encoding = encoding
    }
    
    // baseURL
    var baseURL: URL {
        let urlString = RequestProvider.shared.environment.baseURL
        return URL(string: urlString)!
    }

    /// headers
    /// 字典合并：merge函数
    /// 使用新值 headers.merge(tempHeaders) { _, new in new }
    /// 使用旧值 headers.merge(tempHeaders) { current, _ in current }
    var headers: [String: String]? {
        // header的原始值
        var headers = RequestProvider.shared.httpHeader()
        // ----------- 获取auth信息 -----------
        let auths = self.getAuth(self.parameters, self.api.module)
        /// 合并到header(使用新值覆盖)
        headers.merge(auths) { _, new in new }
        // ----------- 获取业务层设定的header -----------
        if let affairs = self.api.header {
            headers.merge(affairs) { _, new in new }
        }
        return headers
    }
    
    var path: String {
        return self.api.path
    }

    var encoding: ParameterEncoding

    // 请求参数
    var parameters: [String: Any] {
        var params = RequestProvider.shared.parameters()
        if let temp = self.api.params {
            params.merge(temp) { _, new in new }
        }
        return params
    }

    // method
    var method: Moya.Method {
        return self.api.method
    }

    var task: Task {
        return Task.requestParameters(parameters: parameters, encoding: encoding)
    }
}

// MARK: - ---------- 发送请求 -----------

extension RequestTarget {
    // ----------- 返回promise类型 -----------
    func request() -> Promise<Data> {
        return Promise { seal in
            RequestProvider.shared.request(self) { result in
                switch result {
                case .success(let data):
                    seal.fulfill(data)

                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    // ----------- 异步返回 -----------
    func request() async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            RequestProvider.shared.request(self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension RequestTarget {
    // ----------- 返回promise类型 -----------
    public func request<T: Codable>(type: T.Type) -> Promise<T> {
        return Promise { seal in
            firstly {
                return self.request()
            }.compactMap { data in
                try self.parse(data, type: type)
            }.done { model in
                seal.fulfill(model)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    // ----------- 异步返回 -----------
    public func request<T: Codable>(type: T.Type) async throws -> T {
        do {
            let data = try await self.request()
            return try parse(data, type: type)
        } catch {
            throw error
        }
    }
}

// MARK: ----------- 包装header -----------

extension RequestTarget {
    
    // ----------- apiKey -----------
    var apiKey: String? {
        return UserDefaults.standard.string(forKey: k_api_key)
    }
    
    // ----------- 用户id -----------
    var userId: String? {
        return UserDefaults.standard.string(forKey: user_id_key)
    }
    
    public func getAuth(_ params: [String: Any]?, _ module: BudChatModule) -> [String: String] {
        var header: [String: String] = [:]
        
        // ----------- 计算X-Auth -----------
        let authDictionary = getHeaders(params, module)
        let auth = Bud.sorted(to: authDictionary, separator: ",")
        header["X-Auth"] = module.x_auth_prefix + auth
        
        // TODO: 写入X-Budchat-APIKey
        header["X-Budchat-APIKey"] = apiKey
        
        // ----------- access_token -----------
        if let access_token = UserManager.shared.auth?.access_token {
            header["Authorization"] = access_token
        }
        return header
    }

    private func getTimestamp() -> String {
        // ----------- 时间差 -----------
        let diff = UserDefaults.standard.integer(forKey: "SYSTEM_TIME_DIFF")
        print("当前时间和服务器时间差:\(diff)")
        // ----------- 本地时间 -----------
        let now = Int(Date().timeIntervalSince1970 * 1000)
        return String(now - diff)
    }

    private func getHeaders(_ params: [String: Any]?, _ module: BudChatModule) -> [String: Any] {
        let timestamp = getTimestamp()
        let nonce = String.randomAlphanumericString(length: 32)
        var header: [String: String] = [:]
        header["apikey"] = apiKey
        header["mchid"] = userId
        header["nonce"] = nonce
        header["ts"] = timestamp
        header["sign"] = sign(module, params, timestamp, nonce)
        return header
    }

    private func sign(_ module: BudChatModule, _ params: [String: Any]?, _ timestamp: String?, _ nonce: String) -> String {
        guard var param = params else { return "" }
        param["ts"] = timestamp
        param["nonce"] = nonce
        // 加密的内容
        let content = Bud.sorted(to: param)
        // 加密的key
        var key: String?
        switch module {
        case .moment:
            key = UserDefaults.standard.string(forKey: "BudChat.Rsa.Key")
        case .pay:
            key = UserDefaults.standard.string(forKey: "BudChat.Pay.Key")
        case .none:
            key = nil
        }
        if let key {
            return rsa(content: content, by: key)
        }
        return ""
    }

    /// rsa加密-用SHA1WithRSA256(RSA2)算法通过私钥生成签名
    private func rsa(content: String, by privateKey: String) -> String {
        if content.isEmpty { return "" }
        do {
            let privateKey = try PrivateKey(pemEncoded: privateKey)
            do {
                let clear = try ClearMessage(string: content, using: .utf8)
                let encrypted = try clear.signed(with: privateKey, digestType: .sha256)
                return encrypted.base64String
            } catch {
                return ""
            }
        } catch {
            return ""
        }
    }

    /// aes解密
    private func aesEncrypt(content: String, key: String) -> String? {
        do {
            if key.count < 16 {
                return nil
            }
            let iv = String(key.prefix(16))
            let data = Array(base64: content)

            let aes = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs5)
            // 解密
            let ciphertext = try aes.decrypt(data)
            let myData = Data(ciphertext)

            let rusult = String(data: myData, encoding: .utf8)

            return rusult
        } catch {
            return nil
        }
    }
}

// MARK: - ---------- 解析数据 -----------

extension RequestTarget {
    // TODO: 可以在这里统一处理状态
    public func parse<T: Codable>(_ data: Data, type: T.Type) throws -> T {
        do {
            let reponse = try JSONDecoder().decode(BudResponse<T>.self, from: data)
            switch reponse.code {
            // ----------- 成功 -----------
            case ResponseCode.success.rawValue:
                guard let result = reponse.data else {
                    throw NSError(domain: "empty data", code: 0)
                }
                return result

            // ----------- token过期 -----------
            case ResponseCode.vitoken.rawValue:
                throw NSError(domain: "token expired", code: 401)

            default:
                let code = Int(reponse.code) ?? 0
                let msg = reponse.msg ?? "no message"
                throw NSError(domain: msg, code: code)
            }
        } catch {
            throw error
        }
    }
}
