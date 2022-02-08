//
//  MovieTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation
import Moya

enum MovieTarget: MVDBTarget {
    case genres
    case detail(Int)
    case similar(Int)
    
    case latest
    case nowPlaying
    case popular
    case topRated
    case trending
    case upcomming
    case discover
}

extension MovieTarget {
    var path: String {
        switch self {
            case .genres: return "genre/movie/list"
            case .detail(let id): return "/movie/\(id)"
            case .similar(let id): return "/movie/\(id)/similar"
            case .latest: return "/movie/latest"
            case .nowPlaying: return "/movie/now_playing"
            case .popular: return "/movie/popular"
            case .topRated: return "/movie/top_rated"
            case .trending: return "/trending/movie/day"
            case .upcomming: return "/movie/upcoming"
            case .discover: return "/discover/movie"
        }
    }
}
