//
//  UserManager.swift
//
//
//  Created by 文伍 on 2024/9/5.
//

import Foundation
import PromiseKit
import Network

public class UserManager {
    // ----------- 单例 -----------
    static let shared = UserManager()
    private init() {}
    
    // ----------- 判断是否已登录 true是 false否 -----------
    var isLogin: Bool {
        if let _ = UserDefaults.standard.string(forKey: access_token_key) {
            return true
        }
        return false
    }
    
    // ----------- 用户id -----------
    var userId: String {
        return UserDefaults.standard.string(forKey: user_id_key) ?? ""
    }
    
    var apiKey: String {
        return ""
    }
    
    // ----------- 用户信息 -----------
    var user: UserInfo?
    
    // ----------- 认证信息 -----------
    var auth: AuthInfo? {
        return user?.auth
    }
    
    // ----------- 手机号 -----------
    var mobile: String {
        return UserDefaults.standard.string(forKey: mobile_key) ?? ""
    }
    
    // ----------- 获取用户信息 -----------
    func getUser(completion: @escaping (UserInfo?) -> Void) {
        let api = UserApi.getUserInfo
        Bud.request(path: api, type: UserInfo.self).done { info in
            completion(info)
            var user = info
            user.auth = self.auth
            self.saveUser(user)
        }.catch { error in
            let err = error as NSError
            Bud.makeToast(message: err.domain)
        }
    }
    
    // ----------- 修改个人信息 -----------
    func modifyInfo(_ params: [String: Any]) -> Promise<Bool> {
        let api = UserApi.modifyInfo(params)
        return Bud.request(path: api, type: Bool.self)
    }
    
    // ----------- 设置密码 -----------
    func setLoginPassword(_ mobile: String,
                          _ code: String,
                          _ pwd: String,
                          completion: @escaping (Bool?) -> Void)
    {
        var params: [String: Any] = [:]
        params["mobile"] = mobile
        params["code"] = code
        params["password"] = pwd
        params["confirmPassword"] = pwd
        let api = UserApi.setLoginPassword(params)
        Bud.request(path: api, type: Bool.self).done { success in
            completion(success)
        }.catch { error in
            let err = error as NSError
            Bud.makeToast(message: err.domain)
        }
    }
    
    // ----------- 保存用户信息 -----------
    func saveUser(_ user: UserInfo) {
        // ----------- 保存userId -----------
        UserDefaults.standard.setValue(user.id, forKey: user_id_key)
        
        // ----------- 缓存user信息 -----------
        self.user = user
    }
    
    // ----------- 删除用户信息 -----------
    func clearUser() {
        // ----------- 清除access_token -----------
        UserDefaults.standard.removeObject(forKey: access_token_key)
        // ----------- 删除user信息 -----------
        self.user = nil
        // TODO: 在这里清理其他用户信息
    }
}
