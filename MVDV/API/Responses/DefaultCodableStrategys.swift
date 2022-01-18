//
//  DefaultCodableStrategys.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/18.
//

import BetterCodable

typealias DefaultEmptyString = DefaultCodable<String>
typealias DefaultZeroInt = DefaultCodable<Int>

extension String: DefaultCodableStrategy {
    public static var defaultValue: String { "" }
}

extension Int: DefaultCodableStrategy {
    public static var defaultValue: Self { 0 }
}
