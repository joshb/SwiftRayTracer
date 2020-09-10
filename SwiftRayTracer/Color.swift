//
//  Color.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/10/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

struct Color: Equatable {
    var r, g, b, a: Double

    init(r: Double, g: Double, b: Double, a: Double = 1.0) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    var clamped: Color {
        return Color(r: r.clamped(), g: g.clamped(), b: b.clamped(), a: a.clamped())
    }

    static func rgb(_ r: Double = 0.0, _ g: Double = 0.0, _ b: Double = 0.0) -> Color {
        Color(r: r, g: g, b: b)
    }

    static let white = Color(r: 1, g: 1, b: 1)
    static let black = Color(r: 0, g: 0, b: 0)
    static let red = Color(r: 1, g: 0, b: 0)
    static let green = Color(r: 0, g: 1, b: 0)
    static let blue = Color(r: 0, g: 0, b: 1)
}

func == (left: Color, right: Color) -> Bool {
    return left.r.roughlyEqual(right.r) && left.g.roughlyEqual(right.g) && left.b.roughlyEqual(right.b) && left.a.roughlyEqual(right.a)
}

func != (left: Color, right: Color) -> Bool {
    !(left == right)
}

func + (left: Color, right: Color) -> Color {
    Color(r: left.r + right.r, g: left.g + right.g, b: left.b + right.b, a: left.a + right.a)
}

func - (left: Color, right: Color) -> Color {
    Color(r: left.r - right.r, g: left.g - right.g, b: left.b - right.b, a: left.a - right.a)
}

func * (left: Color, right: Color) -> Color {
    Color(r: left.r * right.r, g: left.g * right.g, b: left.b * right.b, a: left.a * right.a)
}

func * (left: Color, right: Double) -> Color {
    Color(r: left.r * right, g: left.g * right, b: left.b * right, a: left.a * right)
}
