//
//  AccountTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/29.
//

import Foundation
import Moya

enum AccountTarget: MVDBTarget {
    case account(sessionId: String)
    case markFavorite(accountId: String, sessionId: String, mediaId: Int, favorited: Bool)
    case favoriteMovies(accountId: String, sessionId: String/*, page: Int*/)
}

extension AccountTarget {
    var path: String {
        switch self {
        case .account: return "/account"
        case .markFavorite(let accountId, _, _, _): return "/account/\(accountId)/favorite"
        case .favoriteMovies(let accountId, _): return "/account/\(accountId)/favorite/movies"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .markFavorite: return .post
        default: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .account(let sessionId):
            return .requestParameters(parameters: ["session_id": sessionId],
                                      encoding: URLEncoding.queryString)
            
        case let .markFavorite(_, sessionId, mediaId, favorited):
            let params = ["session_id": sessionId]
            let body: [String: Any] = [ "media_type": "movie",
                                        "media_id": mediaId,
                                        "favorite": favorited ]
            
            return .requestCompositeParameters(bodyParameters: body,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: params)
        case .favoriteMovies(_, let sessionId)/*(, let page)*/:
            return .requestParameters(parameters: ["session_id": sessionId],
                                      encoding: URLEncoding.queryString)
        @unknown default:
            return .requestPlain
        }
    }
}
