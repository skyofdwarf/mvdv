//
//  MVDBTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import Foundation
import Moya

protocol MVDBTarget: TargetType, AccessTokenAuthorizable {
}

extension MVDBTarget {
    // MARK:  AccessTokenAuthorizable
    var authorizationType: AuthorizationType? { .bearer }
    
    // MARK:  version
    var version: ApiVersion { .v3 }
    
    // MARK: TargeType
    var baseURL: URL { URL(string: "https://api.themoviedb.org/\(version)")! }
    
    var method: Moya.Method { .get }

    var task: Task { .requestPlain }

    var headers: [String: String]? { nil }
}

extension MVDBTarget where Self: RawRepresentable, RawValue == String {
    // MARK: TargeType
    var path: String { rawValue }
}
