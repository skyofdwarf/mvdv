//
//  ConfigurationModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation
import BetterCodable

struct ConfigurationModel: Decodable {
    @DefaultCodable<String> var nostring: String
    @DefaultCodable<Image> var images: Image
    
    @DefaultEmptyArray var change_keys: [String]
    
    struct Image: Decodable {
        @DefaultCodable<String> var base_url: String
        @DefaultCodable<String>  var secure_base_url: String
        @DefaultEmptyArray var backdrop_sizes: [String]
        @DefaultEmptyArray var logo_sizes: [String]
        @DefaultEmptyArray var poster_sizes: [String]
        @DefaultEmptyArray var profile_sizes: [String]
        @DefaultEmptyArray var still_sizes: [String]
    }
}

extension ConfigurationModel.Image: DefaultCodableStrategy {
    public static var defaultValue: ConfigurationModel.Image {
        ConfigurationModel.Image(base_url: "",
                                 secure_base_url: "",
                                 backdrop_sizes: [],
                                 logo_sizes: [],
                                 poster_sizes: [],
                                 profile_sizes: [],
                                 still_sizes: [])
    }
}
