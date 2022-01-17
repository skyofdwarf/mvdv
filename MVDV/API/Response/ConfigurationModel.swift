//
//  ConfigurationModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation

struct ConfigurationModel: Decodable {
    let images: Image
    let change_keys: [String]
    
    struct Image: Decodable {
        let base_url: String?
        let secure_base_url: String?
        let backdrop_sizes: [String]
        let logo_sizes: [String]
        let poster_sizes: [String]
        let profile_sizes: [String]
        let still_sizes: [String]
    }
}
