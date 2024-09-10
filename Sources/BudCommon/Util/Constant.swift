//
//  Constant.swift
//  iAntique
//
//  Created by 文伍 on 2024/5/23.
//

import Foundation
import Network

// auth
let header_auth_name_key = "Authorization"
let header_auth_type_key = "Auth_type"
let default_auth_token = "Basic QnVkS29jOkJ1ZEtvYyNQZW5nQmVpKjIxMTcj"

// user
let k_api_key = "com.budchat.api_key"
let access_token_key = "com.budchat.access_token_key"
let refresh_token_key = "com.budchat.refresh_token_key"
let mobile_key = "com.budchat.mobile.key"
let user_id_key = "com.budchat.user.id"
let guide_show_key = "com.budchat.guide.show"

extension URL {
    
    static func getAgreementString() -> String {
        let urlString = RequestProvider.shared.environment.host
        let mode = (BudThemes.current() == .night) ? "_dark" : ""
        return urlString + "/budchatenduserlicenseagreement\(mode).html"
    }

    static func getPolicyString() -> String {
        let urlString = RequestProvider.shared.environment.host
        let mode = (BudThemes.current() == .night) ? "_dark" : ""
        return urlString + "/budchatenduserlicenseagreement\(mode).html"
    }
}


