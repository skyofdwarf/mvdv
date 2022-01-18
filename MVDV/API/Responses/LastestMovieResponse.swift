//
//  LastestMovieResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import Foundation

struct LastestMovieResponse: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdb_id: String
    let original_language: String
    let original_title: String
    let overview : String
    let popularity: Int
    let poster_path: String?
    let production_companies: [Company]
    let production_countries: [Country]
    let release_date: String
    let revenue: Int
    let runtime: Int
    let spoken_languages: [Language]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: Int
    let vote_count: Int
}
