//
//  DefaultCodableStrategys.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import BetterCodable

extension String: DefaultCodableStrategy {
    public static var defaultValue: String {
        ""
    }
}
