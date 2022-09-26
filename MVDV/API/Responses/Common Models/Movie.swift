//
//  Movie.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import Foundation

struct Movie: Decodable, Hashable {
    let poster_path: String?
    let adult: Bool
    let overview: String
    let release_date: String
    let genre_ids: [Int]
    let id: Int
    let original_title: String
    let original_language: String
    let title: String
    let backdrop_path: String?
    let popularity: Float
    let vote_count: Int
    let video: Bool
    let vote_average: Float
}

extension Movie {
    func backdrop(with imageConfiguration: ImageConfiguration) -> URL? {
        guard let path = backdrop_path else { return nil }
        
        let backdrop_sizes = imageConfiguration.backdrop_sizes
        
        let size = [ "w780", "w1280", "w300", "original" ].first {
            backdrop_sizes.contains($0)
        } ?? backdrop_sizes.last
            
        guard let size else { return nil }
        
        return URL(string: imageConfiguration.secure_base_url)?
            .appendingPathComponent(size)
            .appendingPathComponent(path)
    }
    
    func poster(with imageConfiguration: ImageConfiguration) -> URL? {
        guard let path = poster_path else { return nil }
       
        let poster_sizes = imageConfiguration.poster_sizes
        
        let size = [ "342", "w500", "w780", "original", "w185", "w154" ].first {
            poster_sizes.contains($0)
        } ?? poster_sizes.last
        
        guard let size else { return nil }
        
        return URL(string: imageConfiguration.secure_base_url)?
            .appendingPathComponent(size)
            .appendingPathComponent(path)
    }
}
