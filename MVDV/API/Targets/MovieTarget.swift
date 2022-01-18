//
//  MovieTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation
import Moya

enum MovieTarget: String, MVDBTarget {
    case genres = "genre/movie/list"

    case latest = "/movie/latest"
    case nowPlaying = "/movie/now_playing"
    case popular = "/movie/popular"
    case topRated = "/movie/top_rated"
    case upcomming = "/movie/upcoming"

    case discover = "/discover/movie"
}
