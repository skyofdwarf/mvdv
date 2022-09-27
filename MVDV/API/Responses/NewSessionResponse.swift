//
//  NewSessionResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/28.
//

import Foundation

struct NewSessionResponse: Decodable {
    let success: Bool
    let session_id: String
}
