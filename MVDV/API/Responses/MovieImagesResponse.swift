//
//  MovieImagesResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/10.
//

import Foundation

struct MovieImagesResponse: Decodable {
    //let id: Int
    let backdrops: [Backdrop]
    let posters: [Poster]
    
    struct Poster: Decodable {
        let aspect_ratio: Float
        let file_path: String
        let height: Int
        let iso_639_1: String?
        let vote_average: Float
        let vote_count: Int
        let width: Int
    }
    
    struct Backdrop: Decodable {
        let aspect_ratio: Float
        let file_path: String
        let height: Int
        let iso_639_1: String?
        let vote_average: Float
        let vote_count: Int
        let width: Int
    }
}
