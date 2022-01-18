//
//  CompanyDetailModel.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/19.
//

import Foundation
import SwiftUI

struct Company: Decodable {
    let description: String
    let headquarters: String
    let homepage: String
    let id: Int
    let logo_path: String
    let name: String
    let origin_country: String
}
