//
//  MatrixTests.swift
//  SwiftRayTracerTests
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import XCTest

class MatrixTests: XCTestCase {
    func testMatrix4_transposed() throws {
        let m = Matrix4(m: [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 10, 11, 12,
            13, 14, 15, 16,
        ])
        XCTAssertEqual(m.transposed, Matrix4(m: [
            1, 5, 9, 13,
            2, 6, 10, 14,
            3, 7, 11, 15,
            4, 8, 12, 16,
        ]))
    }

    func testMatrix4_inverse() throws {
        let a = Matrix4.translation(x: 1, y: 2, z: 3)
        let b = a.inverse!
        XCTAssertEqual(b, Matrix4(m: [
            1, 0, 0, -1,
            0, 1, 0, -2,
            0, 0, 1, -3,
            0, 0, 0, 1,
        ]))

        let c = Matrix4.rotation(angle: Double.pi / 2, v: Vector4.vector(x: 3, y: 2, z: 1).normalized)
        let d = c.inverse!
        XCTAssertEqual(d, Matrix4(m: [
            0.64285, 0.69583, -0.32023, 0,
            0.16131, 0.28571, 0.94464, 0,
            0.74880, -0.65892, 0.07142, 0,
            0, 0, 0, 1,
        ]))

        XCTAssertEqual((a * c) * d, a)
        XCTAssertEqual((c * a) * b, c)
    }

    func testMatrix4_translation() throws {
        let m = Matrix4.translation(x: 2, y: 3, z: 4)
        XCTAssertEqual(m, Matrix4(m: [
            1, 0, 0, 2,
            0, 1, 0, 3,
            0, 0, 1, 4,
            0, 0, 0, 1,
        ]))
        XCTAssertEqual(m * Vector4.point(x: 1, y: 2, z: 3), Vector4.point(x: 3, y: 5, z: 7))
    }

    func testMatrix4_scaling() throws {
        let m = Matrix4.scaling(Vector4(x: 2, y: 3, z: 4, w: 1))
        XCTAssertEqual(m, Matrix4(m: [
            2, 0, 0, 0,
            0, 3, 0, 0,
            0, 0, 4, 0,
            0, 0, 0, 1,
        ]))
        XCTAssertEqual(m * Vector4.point(x: 1, y: 2, z: 3), Vector4.point(x: 2, y: 6, z: 12))
    }

    func testMatrix4_rotation() throws {
        let m = Matrix4.rotation(angle: Double.pi / 2, v: Vector4.vector(x: 1, y: 4, z: 9).normalized)
        XCTAssertEqual(m, Matrix4(m: [
            0.01020, -0.86832, 0.49589, 0,
            0.94995, 0.16326, 0.26633, 0,
            -0.31222, 0.46836, 0.82653, 0.0,
            0.0, 0.0, 0.0, 1.0,
        ]))
        XCTAssertEqual(m * Vector4.point(x: 1, y: 2, z: 3), Vector4.point(x: -0.23874, y: 2.07547, z: 3.10409))
    }

    func testMatrix4_shearing() throws {
        let p = Vector4.point(x: 1, y: 2, z: 3)
        XCTAssertEqual(Matrix4.shearing(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0) * p, Vector4.point(x: 3, y: 2, z: 3))
        XCTAssertEqual(Matrix4.shearing(xy: 0, xz: 1, yx: 0, yz: 0, zx: 0, zy: 0) * p, Vector4.point(x: 4, y: 2, z: 3))
        XCTAssertEqual(Matrix4.shearing(xy: 0, xz: 0, yx: 1, yz: 0, zx: 0, zy: 0) * p, Vector4.point(x: 1, y: 3, z: 3))
        XCTAssertEqual(Matrix4.shearing(xy: 0, xz: 0, yx: 0, yz: 1, zx: 0, zy: 0) * p, Vector4.point(x: 1, y: 5, z: 3))
        XCTAssertEqual(Matrix4.shearing(xy: 0, xz: 0, yx: 0, yz: 0, zx: 1, zy: 0) * p, Vector4.point(x: 1, y: 2, z: 4))
        XCTAssertEqual(Matrix4.shearing(xy: 0, xz: 0, yx: 0, yz: 0, zx: 0, zy: 1) * p, Vector4.point(x: 1, y: 2, z: 5))
    }

    func testMatrix4_chain_operations() throws {
        let m = Matrix4.identity.translate(x: 1, y: 2, z: 3).rotate(angle: Double.pi / 2, x: 1, y: 4, z: 9).scale(x: 10, y: 20, z: 30)
        XCTAssertEqual(m, Matrix4(m: [
            10, -50, 130, 300,
            260, 320, 700, 3000,
            150, 1110, 2430, 9660,
            0, 0, 0, 1,
        ]))
    }
}
