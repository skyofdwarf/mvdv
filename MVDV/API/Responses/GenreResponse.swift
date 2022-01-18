//
//  GenreResponse.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import Foundation

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct GenreResponse: Decodable {
    let genres: [Genre]
}

#if DEBUG
extension GenreResponse {
    static let json = #"""
    {
      "genres": [
        {
          "id": 28,
          "name": "Action"
        }
      ]
    }
    """#
}
#endif
