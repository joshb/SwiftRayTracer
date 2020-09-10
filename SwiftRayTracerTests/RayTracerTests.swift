//
//  RayTracerTests.swift
//  SwiftRayTracerTests
//
//  Created by Josh Beam on 9/10/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import XCTest

class RayTracerTests: XCTestCase {
    func testRayTracerPerformance() throws {
        self.measure {
            let size = 800
            let rayOrigin = Vector4.point(x: 0.0, y: 0.0, z: -10.0)
            let rayTracer = RayTracer(
                width: size,
                height: size,
                lights: [
                    PointLight(position: .point(x: -5, y: 5, z: 5), color: .white),
                    PointLight(position: .point(x: 5, y: 5, z: -5), color: .white)
                ],
                objects: [
                    Sphere(
                        transform: .translation(x: -1, z: 2.5),
                        material: Material(color: .red)
                    ),
                    Sphere(
                        transform: .translation(x: 0.5),
                        material: Material(color: .green)
                    ),
                ]
            )

            _ = rayTracer.render(rayOrigin: rayOrigin)
        }
    }
}
