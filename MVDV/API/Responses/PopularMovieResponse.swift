//
//  PopularMovieResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import Foundation

struct PopularMovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    
    let total_pages: Int
    let total_results: Int
}
