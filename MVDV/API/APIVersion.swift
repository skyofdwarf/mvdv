//
//  APIVersion.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import Foundation

enum ApiVersion: String, CustomStringConvertible {
    case v3 = "3"
    
    var description: String { rawValue }
}
