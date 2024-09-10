//
//  RequestApi.swift
//  iBudChat
//
//  Created by 文伍 on 2024/7/9.
//

import Foundation
import Moya

// MARK: - ---------- 网络请求 Api协议 -----------

/*
 * 便于扩展、外部可定义结构体遵循该协议
 * path 接口
 * header 请求头
 * params 请求参数
 * method POST、GET等
 */
public protocol RequestApi {
    // ----------- 接口 -----------
    var path: String { get }

    // ----------- 请求头 -----------
    var header: [String: String]? { get }

    // ----------- 请求参数 -----------
    var params: [String: Any]? { get }

    // ----------- 请求方式 -----------
    var method: Moya.Method { get }
    
    // ----------- Module -----------
    var module: BudChatModule { get }
}

public extension RequestApi {
    var header: [String: String]? { return nil }

    var method: Moya.Method { return .post }
    
    var module: BudChatModule { return BudChatModule.none }
}
