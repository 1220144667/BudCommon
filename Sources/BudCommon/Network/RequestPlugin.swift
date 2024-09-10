//
//  RequestPlugin.swift
//  BudMall
//
//  Created by 文伍 on 2024/4/23.
//  网络请求参数打印

import Foundation
import Logging
import Moya

extension RequestProvider.Plugin: PluginType {
    // ----------- 打印header、body参数 -----------
    func willSend(_ request: any RequestType, target _: any TargetType) {
        #if DEBUG
            let logger = Logger(label: "com.reqeust.log")
            guard let request = request.request else { return }
            logger.info("======= request start =======")
            if let _ = request.httpBody {
                let content = "URL: \(request.url!)" + "\n" + "Method: \(request.httpMethod ?? "")" + "\n" + "Body: " + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")"
                logger.info("\(content)")
            } else {
                let content = "URL: \(request.url!)" + "\n" + "Method: \(request.httpMethod ?? "")"
                logger.info("\(content)")
            }
            if let headerView = request.allHTTPHeaderFields {
                logger.info("Header: \(headerView)")
            }
            logger.info("======= request end =======")
        #endif
    }

    // ----------- 打印响应数据 -----------
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target _: TargetType) {
        #if DEBUG
            let logger = Logger(label: "com.reqeust.log")
            logger.info("======= response start =======")
            switch result {
            case let .success(success):
                let jsonData = Bud.dataToDictionary(success.data)
                logger.info("Response：\(String(describing: jsonData))")
            case let .failure(failure):
                let errorCode = failure.errorCode
                let description = failure.errorDescription ?? ""
                logger.info("Error:\(errorCode)\n\(description)")
            }
            logger.info("======= response end =======")
        #endif
    }
}
