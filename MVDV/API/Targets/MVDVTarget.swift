//
//  MVDVTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import Foundation
import Moya

protocol MVDVTarget: TargetType, AccessTokenAuthorizable {
}

extension MVDVTarget {
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

extension MVDVTarget where Self: RawRepresentable, RawValue == String {
    // MARK: TargeType
    var path: String { rawValue }
}
