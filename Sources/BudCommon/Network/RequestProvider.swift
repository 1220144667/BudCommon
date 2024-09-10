//
//  RequestProvider.swift
//  iMarket
//
//  Created by 洪陪 on 2023/8/31.
//

import Alamofire
import Foundation
import Moya

struct RequestProvider {
    static let shared = RequestProvider()

    private var timestap = ""

    // 私有初始化，避免在外部调用
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = Constant.timeout
        let session = Session(configuration: configuration, startRequestsImmediately: false)
        // 构造器
        provider = MoyaProvider<RequestTarget>(session: session, plugins: [Plugin()])
    }

    private var provider: MoyaProvider<RequestTarget>

    #if DEBUG
        var environment = Environment.debug(Host.debug)
    #else
        var environment = Environment.release(Host.release)
    #endif

    struct Plugin {}
}

extension RequestProvider {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }

    // 构造header
    func httpHeader() -> [String: String] {
        return [header_auth_name_key: accessToken()]
    }

    // ----------- 获取access_token -----------
    private func accessToken() -> String {
        if let token = UserDefaults.standard.string(forKey: access_token_key), !token.isEmpty {
            return "Bearer " + token
        }
        return default_auth_token
    }

    // 构造携带的公共数据
    func parameters() -> [String: Any] {
        return [:]
    }
}

extension RequestProvider {
    /// 发起网络请求（Data）
    /// - Parameter request: 请求类
    /// - Returns: Data
    func request(_ request: RequestTarget, completion: @escaping (Result<Data, Error>) -> Void) {
        // 无网络
        if RequestProvider.isNetworkConnect == false {
            let message = "Check network".localized()
            let error = NSError(domain: message, code: 0)
            completion(.failure(error))
        }
        self.provider.request(request) { result in
            switch result {
            case let .success(response):
                completion(.success(response.data))
                
            case let .failure(error):
                let err = error as NSError
                let code = err.code
                let msg = err.localizedDescription
                completion(.failure(err))
            }
        }
    }
}
