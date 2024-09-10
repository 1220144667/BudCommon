//
//  Config.swift
//  iBudChat
//
//  Created by 文伍 on 2024/7/9.
//

import Foundation

// 网络请求Code
public enum ResponseCode: String {
    case success = "SUCCESS" // 成功
    case vitoken = "401" // token失效,需要重新登录
    case noneData = "-888" // 请求数据为空
    case noneNetwork = "-999" // 无网络
    case dataParseFail = "-666" // 数据解析失败
}

/// 定义域名
public enum Host: String {
    case debug = "119.45.193.205:9601"
    case release = "botim.n-chat.com.ng"
}

public enum Constant {
    /// 协议
    static let hyperTextTransferProtocol = "http://"
    static let hyperTextTransferProtocolSecure = "https://"
    static let timeout: Double = 30
    static let requestErrorDomain = "com.budchat.error"
}

public enum Environment {
    case debug(Host)

    case release(Host)

    var baseURL: String {
        switch self {
        case let .debug(host):
            return Constant.hyperTextTransferProtocol + host.rawValue
        case let .release(host):
            return Constant.hyperTextTransferProtocolSecure + host.rawValue
        }
    }

    var host: String {
        switch self {
        case let .debug(host):
            return host.rawValue
        case let .release(host):
            return host.rawValue
        }
    }
}

// MARK: - ---------- 请求结果 -----------

public struct BudResponse<T: Codable>: Codable {
    var code: String = "0"
    var msg: String?
    var data: T?
}

public enum BudChatModule {
    // ----------- 朋友圈 -----------
    case moment
    // ----------- 支付 -----------
    case pay
    // ----------- 默认 -----------
    case none
    
    var x_auth_prefix: String {
        switch self {
        case .moment:
            return "BUDCHATIMV1 "
        case .pay:
            return "BUDCHATPAYV1 "
        case .none:
            return ""
        }
    }
}
