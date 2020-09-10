//
//  PointLightTests.swift
//  SwiftRayTracerTests
//
//  Created by Josh Beam on 9/10/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import XCTest

class PointLightTests: XCTestCase {
    func testPointLight_lighting() throws {
        let material = Material(color: .white)
        let position = Vector4.point(x: 0, y: 0, z: 0)
        let eye = Vector4.vector(x: 0, y: 0, z: -1)
        let normal = Vector4.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: -1, y: 10, z: -5), color: .rgb(0.2, 0.5, 0.75))
        XCTAssertEqual(light.lighting(material: material, position: position, eye: eye, normal: normal), Color.rgb(0.09126, 0.22817, 0.34226))
    }
}
