//
//  UserApi.swift
//  iAntique
//
//  Created by 文伍 on 2024/5/24.
//

import Foundation
import Moya

public enum LoginTypeWrapper: String {
    case sms
    case password
    case third
}

public enum UserApi: RequestApi {
    // ----------- 发送验证码 -----------

    case sendSms(String)

    // ----------- 检查账号是否注册 -----------
    case check([String: Any], LoginTypeWrapper)

    // ----------- 登录 -----------
    case login([String: Any], LoginTypeWrapper)

    // ----------- token刷新 -----------
    case getRefreshtoken

    // ----------- 忘记密码 -----------
    case forgetPwd([String: Any])

    // ----------- 验证手机号是否已注册 -----------
    case authMobile(String)
    
    // ----------- 获取用户信息 -----------
    case getUserInfo
    
    // ----------- 修改用户信息 -----------
    case modifyInfo([String: Any])
    
    // ----------- 设置登录密码 -----------
    case setLoginPassword([String: Any])
    
    public var path: String {
        switch self {
        case .sendSms:
            return "business/app/anonymity/member/sendSms"
        case .check:
            return "business/app/anonymity/member/loginbefore"
        case .login:
            return "auth/oauth/token"
        case .getRefreshtoken:
            return "business/app/anonymity/member/getRefreshTokenParam"
        case .forgetPwd:
            return "business/app/anonymity/member/forgetPWD"
        case .authMobile:
            return "business/app/anonymity/member/isExists"
        case .getUserInfo:
            return "business/app/member/getMemberInfo"
        case .modifyInfo:
            return "business/app/member/updateMember"
        case .setLoginPassword:
            return "business/app/member/setLoginPassword"
        }
    }
    
    public var params: [String : Any]? {
        switch self {
        case let .check(params, _):
            return params
        case let .sendSms(mobile):
            return ["mobile": mobile]
        case let .login(params, _):
            return params
        case let .forgetPwd(params):
            return params
        case let .authMobile(mobile):
            return ["mobile": mobile]
        case .setLoginPassword(let params):
            return params
        case .modifyInfo(let params):
            return params
        default:
            return [:]
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    public var header: [String: String]? {
        switch self {
        case let .check(_, type):
            return ["Auth_type": type.rawValue]

        case let .login(_, type):
            return ["Auth_type": type.rawValue]

        default:
            return nil
        }
    }
}
