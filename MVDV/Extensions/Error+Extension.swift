//
//  Error+Extension.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import Foundation
import Moya

extension Error {
    var isMoyaError: Bool {
        (self as? MoyaError) != nil
    }
    
    var isInvalidAccessTokenError: Bool {
        switch self {
        case .statusCode(let response) as MoyaError:
            return HTTPStatusCode.unauthorized == response.statusCode
        default:
            return false
        }
    }
    
    var isDecodingError: Bool {
        switch self {
        case .objectMapping as MoyaError:
            return true
        default:
            return false
        }
    }
}
