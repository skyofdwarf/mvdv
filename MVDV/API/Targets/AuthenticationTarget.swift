//
//  AuthenticationTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/28.
//

import Foundation
import Moya

enum AuthenticationTarget: MVDBTarget {
    case authenticationToken
    case newSession(requestToken: String)
}

extension AuthenticationTarget {
    var path: String {
        switch self {
            case .authenticationToken: return "/authentication/token/new"
            case .newSession: return "/authentication/session/new"
        }
    }
    
    var task: Task {
        switch self {
            case .newSession(let requestToken):
                return .requestParameters(parameters: ["request_token": requestToken],
                                          encoding: URLEncoding.queryString)
            default:
                return .requestPlain
        }
    }
}

extension AuthenticationTarget {
    static let authenticationUrl = "https://www.themoviedb.org/authenticate"
    static let successRedirectUrl = "/authenticate/allow"
    static let successResponseHeader = "Authentication-Callback"
    
    static func authenticationUrl(requestToken: String) -> URL? {
        URL(string: authenticationUrl)?.appendingPathComponent(requestToken)
    }
}
