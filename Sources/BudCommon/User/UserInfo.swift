//
//  UserInfo.swift
//  iAntique
//
//  Created by 文伍 on 2024/5/13.
//

import Foundation

public struct UserInfo: Codable {
    // ----------- id -----------
    var id: String?
    // ----------- name -----------
    var username: String?
    // ----------- name -----------
    var name: String?
    // ----------- 手机号 -----------
    var mobile: String?
    // ----------- 邮箱 -----------
    var email: String?
    // ----------- 头像 -----------
    var avatar: String?
    // ----------- 级别 -----------
    var level: String?
    // ----------- 最后登录时间 -----------
    var lastLoginTime: String?
    // ----------- 状态 -----------
    var status: String?
    // ----------- auth信息 -----------
    var auth: AuthInfo?
    // ----------- auth创建时间 -----------
    // INVALID 密码无效
    var pwdStatus: String?

    var passwordValid: Bool {
        guard let status = pwdStatus else { return false }
        return status == "VALID"
    }
}
