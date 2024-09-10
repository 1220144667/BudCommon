//
//  RequestExtension.swift
//  iBudChat
//
//  Created by 文伍 on 2024/7/9.
//

import Foundation
import Moya
import PromiseKit

extension Bud {
    // ----------- 网络请求 返回Data -----------
    @discardableResult
    static func request(path: RequestApi, encoding: ParameterEncoding = JSONEncoding.default) -> Promise<Data> {
        return RequestTarget.create(path, encoding: encoding).request()
    }

    // ----------- 网络请求 返回解析结果 -----------
    @discardableResult
    static func request<T: Codable>(path: RequestApi, type: T.Type, encoding: ParameterEncoding = JSONEncoding.default) -> Promise<T> {
        return RequestTarget.create(path, encoding: encoding).request(type: type)
    }
    // TODO: 扩展其他类型
}
