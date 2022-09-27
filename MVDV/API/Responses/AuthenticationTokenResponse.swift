//
//  AuthenticationTokenResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/27.
//

import Foundation

struct AuthenticationTokenResponse: Decodable {
    let success: Bool
    let expires_at: String
    let request_token: String
}
