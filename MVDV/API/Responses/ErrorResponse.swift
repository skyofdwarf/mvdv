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
