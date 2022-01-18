//
//  TopRatedMovieResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import Foundation

struct TopRatedMovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    
    let total_pages: Int
    let total_results: Int
}
