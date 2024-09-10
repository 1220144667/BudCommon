//
//  AuthInfo.swift
//  iAntique
//
//  Created by 文伍 on 2024/5/24.
//

import Foundation

public struct AuthInfo: Codable {
    public var access_token: String? // 后续访问其他接口的token
    public var expires_in: Int64? // 过期时间
    public var refresh_token: String? // 刷新access_token的token
    public var scope: String? // 作用域
    public var token_type: String? // token类型
    public var update_at: Date?
}

public struct RefreshTokenData: Codable {
    public var clientId: String?
    public var originSecret: String?
    public var key: String?
}
