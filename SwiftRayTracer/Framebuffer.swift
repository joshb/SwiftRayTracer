//
//  Framebuffer.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

class Framebuffer {
    private let _bytesPerPixel = 4

    private let _width: Int
    private let _height: Int
    private var _bytes: [UInt8]

    init(width: Int, height: Int) {
        _width = width
        _height = height
        _bytes = [UInt8](repeating: 0, count: width * height * _bytesPerPixel)
    }

    var image: CGImage {
        let data = CFDataCreate(nil, _bytes, _bytes.count)
        let provider = CGDataProvider(data: data!)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        return CGImage(width: _width, height: _height, bitsPerComponent: 8, bitsPerPixel: _bytesPerPixel * 8, bytesPerRow: _bytesPerPixel * _width,
                            space: colorSpace, bitmapInfo: .byteOrder32Big, provider: provider!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
    }

    func setPixel(x: Int, y: Int, color: Color) {
        let index = (_width * y + x) * _bytesPerPixel
        let c = color.clamped
        _bytes[index+0] = UInt8(c.r * 255.0)
        _bytes[index+1] = UInt8(c.g * 255.0)
        _bytes[index+2] = UInt8(c.b * 255.0)
        _bytes[index+3] = UInt8(c.a * 255.0)
    }
}
