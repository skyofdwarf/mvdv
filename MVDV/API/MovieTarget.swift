//
//  MovieTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation
import Moya

enum ApiVersion: String, CustomStringConvertible {
    case v3 = "3"
    
    var description: String { rawValue }
}

enum MovieTarget: String, AccessTokenAuthorizable {
    case configuration = "/configuration" ///< TODO: seprate tawrget
    
    case nowPlaying = "/movie/now_playing"
    case upcomming = "/movie/upcoming"
    case popular = "/movie/popular"
    case topRated = "/movie/top_rated"
//    case upcomming
//    case trending
//    case discover
    
    var version: ApiVersion { .v3 }
    var authorizationType: AuthorizationType? { .bearer }
}

extension MovieTarget: TargetType {
    /// The target's base `URL`.
    var baseURL: URL { URL(string: "https://api.themoviedb.org/\(version)")! }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { rawValue }

    /// The HTTP method used in the request.
    var method: Moya.Method { .get }

    /// The type of HTTP task to be performed.
    var task: Task { .requestPlain }

    /// The headers to be used in the request.
    var headers: [String: String]? { nil }
}
