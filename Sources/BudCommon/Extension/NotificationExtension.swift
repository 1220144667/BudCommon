//
//  NotificationExtension.swift
//  BudMall
//
//  Created by 文伍 on 2024/4/23.
//

import Foundation
import PromiseKit
import UIKit


public enum NotificationName: String {

    // ----------- 登录成功 -----------
    case login = "name.login.bud"
    
    // ----------- 退出登录 -----------
    case logout = "name.logout.bud"
    
    // ----------- 刷新user信息 -----------
    case refreshUser = "name.refresh.user.bud"
    
    // ----------- 键盘将要弹出 -----------
    case keyboardWillShow
    
    // ----------- 键盘将要消失 -----------
    case keyboardWillHidden
    
    var string: String {
        return rawValue
    }
    
    var value: Notification.Name {
        switch self {
        case .keyboardWillShow:
            return UIResponder.keyboardWillShowNotification
        case .keyboardWillHidden:
            return UIResponder.keyboardWillHideNotification
        default:
            return Notification.Name(string)
        }
    }
}

public extension NotificationCenter {
    
    // 添加观察者
    static func addObserver(_ observer: Any, selector: Selector, name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: name.value,
                                               object: object)
    }
    
    // 发送消息
    static func post(name: NotificationName, object: Any?, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name.value,
                                        object: object,
                                        userInfo: userInfo)
    }

    // 移除观察者
    static func removeObserver(_ observer: Any, name: NotificationName) {
        NotificationCenter.default.removeObserver(observer,
                                                  name: name.value,
                                                  object: nil)
    }

    // 移除所有观察者
    static func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
