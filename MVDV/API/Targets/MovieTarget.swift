//
//  MovieTarget.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
//

import Foundation
import Moya

enum MovieTarget: MVDVTarget {
    case genres
    case detail(Int, stated: Bool)
    case similar(Int)
    //case images(Int)
    //case videos(Int)
    //case credits(Int)
    case latest
    case nowPlaying
    case popular
    case topRated
    case trending
    case upcoming
    case discover
    case search(query: String, page: Int)
}

extension MovieTarget {
    var path: String {
        switch self {
        case .genres: return "genre/movie/list"
        case .detail(let id, _): return "/movie/\(id)"
        case .similar(let id): return "/movie/\(id)/similar"
            //case .images(let id): return "/movie/\(id)/images"
            //case .videos(let id): return "/movie/\(id)/videos"
            //case .credits(let id): return "/movie/\(id)/credits"
        case .latest: return "/movie/latest"
        case .nowPlaying: return "/movie/now_playing"
        case .popular: return "/movie/popular"
        case .topRated: return "/movie/top_rated"
        case .trending: return "/trending/movie/day"
        case .upcoming: return "/movie/upcoming"
        case .discover: return "/discover/movie"
        case .search: return "/search/movie"
        }
    }
    
    var task: Task {
        switch self {
        case .detail(_, let stated):
            let appendings = (["videos", "images", "similar", "credits"] +
                              (stated ? ["account_states"] : []))
                .joined(separator: ",")
            
            return .requestParameters(parameters: ["append_to_response": appendings],
                                      encoding: URLEncoding.queryString)
        case .search(let query, let page):
            return .requestParameters(parameters: ["query": query,
                                                   "page": page],
                                      encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
