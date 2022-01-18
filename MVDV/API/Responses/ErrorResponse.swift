//
//  ErrorResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import Foundation

struct ErrorResponse: Decodable {
    let status_message: String
    let status_code: Int
}

#if DEBUG
extension ErrorResponse {
    static let json = #"""
    {
      "status_message": "Invalid API key: You must be granted a valid key.",
      "success": false,
      "status_code": 7
    }
    """#
}
#endif
