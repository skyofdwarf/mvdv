//
//  AuthenticationTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/28.
//

import Foundation
import Moya

enum AuthenticationTarget: MVDBTarget {
    case requestToken
    case newSession(requestToken: String)
}

extension AuthenticationTarget {
    var path: String {
        switch self {
        case .requestToken: return "/authentication/token/new"
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
