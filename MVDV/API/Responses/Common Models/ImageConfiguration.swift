//
//  ImageConfiguration.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/09/27.
//

import Foundation

struct ImageConfiguration: Decodable {
    var base_url: String = "http://image.tmdb.org/t/p/"
    var secure_base_url: String = "https://image.tmdb.org/t/p/"
    var backdrop_sizes: [String] = []
    var logo_sizes: [String] = []
    var poster_sizes: [String] = []
    var profile_sizes: [String] = []
    var still_sizes: [String] = []
}
