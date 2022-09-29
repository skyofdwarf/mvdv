//
//  AccountResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/30.
//

import Foundation

struct Avatar: Decodable {
    struct Gravatar: Decodable {
        let hash: String?
    }
    let gravatar: Gravatar?
}

struct AccountResponse: Decodable {
    let avatar: Avatar?
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
}
