//
//  ConfigurationResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation

struct ConfigurationImage: Decodable {
    let base_url: String
    let secure_base_url: String
    let backdrop_sizes: [String]
    let logo_sizes: [String]
    let poster_sizes: [String]
    let profile_sizes: [String]
    let still_sizes: [String]
}

struct ConfigurationResponse: Decodable {
    let images: ConfigurationImage
    let change_keys: [String]    
}
