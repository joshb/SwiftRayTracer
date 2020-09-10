//
//  DoubleExtension.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/10/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

extension Double {
    func clamped(min: Double = 0.0, max: Double = 1.0) -> Double {
        var result = self
        if result < min {
            result = min
        } else if result > max {
            result = max
        }
        return result
    }

    func roughlyEqual(_ other: Double) -> Bool {
        let e = 0.00001
        let diff = self - other
        return diff > -e && diff < e
    }
}
