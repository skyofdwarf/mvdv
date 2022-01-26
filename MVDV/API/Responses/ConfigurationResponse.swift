//
//  ConfigurationResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/17.
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

struct ConfigurationResponse: Decodable {
    let images: ImageConfiguration
    let change_keys: [String]    
}

#if DEBUG
extension ConfigurationResponse {
    static let json = #"""
    {
      "images": {
        "base_url": "http://image.tmdb.org/t/p/",
        "secure_base_url": "https://image.tmdb.org/t/p/",
        "backdrop_sizes": [
          "w300",
          "w780",
          "w1280",
          "original"
        ],
        "logo_sizes": [
          "w45",
          "w92",
          "w154",
          "w185",
          "w300",
          "w500",
          "original"
        ],
        "poster_sizes": [
          "w92",
          "w154",
          "w185",
          "w342",
          "w500",
          "w780",
          "original"
        ],
        "profile_sizes": [
          "w45",
          "w185",
          "h632",
          "original"
        ],
        "still_sizes": [
          "w92",
          "w185",
          "w300",
          "original"
        ]
      },
      "change_keys": [
        "adult",
        "air_date",
        "also_known_as",
        "alternative_titles",
        "biography",
        "birthday",
        "budget",
        "cast",
        "certifications",
        "character_names",
        "created_by",
        "crew",
        "deathday",
        "episode",
        "episode_number",
        "episode_run_time",
        "freebase_id",
        "freebase_mid",
        "general",
        "genres",
        "guest_stars",
        "homepage",
        "images",
        "imdb_id",
        "languages",
        "name",
        "network",
        "origin_country",
        "original_name",
        "original_title",
        "overview",
        "parts",
        "place_of_birth",
        "plot_keywords",
        "production_code",
        "production_companies",
        "production_countries",
        "releases",
        "revenue",
        "runtime",
        "season",
        "season_number",
        "season_regular",
        "spoken_languages",
        "status",
        "tagline",
        "title",
        "translations",
        "tvdb_id",
        "tvrage_id",
        "type",
        "video",
        "videos"
      ]
    }
    """#
}
#endif
