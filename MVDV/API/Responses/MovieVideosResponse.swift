//
//  MovieVideosResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/10.
//

import Foundation

struct MovieVideosResponse: Decodable {
    //let id: Int
    let results: [MovieVideo]
    
    struct MovieVideo: Decodable {
        let iso_639_1: String
        let iso_3166_1: String
        let name: String
        let key: String
        let site: String
        let size: Int
        let type: String
        let official: Bool
        let published_at: String
        let id: String
    }
}
