//
//  Vector4.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

/// Represents a 4D vector.
struct Vector4: Equatable {
    var x = 0.0
    var y = 0.0
    var z = 0.0
    var w = 0.0

    func dotProduct(_ v: Vector4) -> Double {
        x*v.x + y*v.y + z*v.z + w*v.w
    }

    func crossProduct(_ v: Vector4) -> Vector4 {
        .vector(x: y*v.z - z*v.y,
                y: z*v.x - x*v.z,
                z: x*v.y - y*v.x)
    }

    var length: Double {
        sqrt(dotProduct(self))
    }

    var normalized: Vector4 {
        let len = length
        return Vector4(x: x / len, y: y / len, z: z / len, w: w / len)
    }

    func reflect(n: Vector4) -> Vector4 {
        self - n * 2 * self.dotProduct(n)
    }

    static func point(x: Double, y: Double, z: Double) -> Vector4 {
        Vector4(x: x, y: y, z: z, w: 1)
    }

    static func vector(x: Double, y: Double, z: Double) -> Vector4 {
        Vector4(x: x, y: y, z: z, w: 0)
    }
}

func == (left: Vector4, right: Vector4) -> Bool {
    return left.x.roughlyEqual(right.x) && left.y.roughlyEqual(right.y) && left.z.roughlyEqual(right.z) && left.w.roughlyEqual(right.w)
}

func != (left: Vector4, right: Vector4) -> Bool {
    !(left == right)
}

func + (left: Vector4, right: Vector4) -> Vector4 {
    Vector4(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z, w: left.w + right.w)
}

func - (left: Vector4, right: Vector4) -> Vector4 {
    Vector4(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z, w: left.w - right.w)
}

func * (left: Vector4, right: Vector4) -> Vector4 {
    Vector4(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z, w: left.w * right.w)
}

func * (left: Vector4, right: Double) -> Vector4 {
    Vector4(x: left.x * right, y: left.y * right, z: left.z * right, w: left.w * right)
}
