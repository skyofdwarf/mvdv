//
//  ErrorResponseModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import Foundation
import BetterCodable

struct ErrorResponseModel: Decodable {
    @DefaultEmptyString var status_message: String
    @DefaultZeroInt var status_code: Int
}
