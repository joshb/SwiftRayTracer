//
//  Matrix.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

protocol Matrix {
    var size: Int { get }
    subscript(row: Int, column: Int) -> Double { get }
}

struct SubMatrix: Matrix {
    var m: Matrix
    var subRow, subColumn: Int

    var size: Int {
        m.size - 1
    }

    subscript(row: Int, column: Int) -> Double {
        var actualRow = row
        if actualRow >= subRow {
            actualRow += 1
        }
        var actualColumn = column
        if actualColumn >= subColumn {
            actualColumn += 1
        }
        return m[actualRow, actualColumn]
    }
}

extension Matrix {
    func submatrix(row: Int, column: Int) -> Matrix {
        SubMatrix(m: self, subRow: row, subColumn: column)
    }

    func minor(row: Int, column: Int) -> Double {
        submatrix(row: row, column: column).determinant
    }

    func cofactor(row: Int, column: Int) -> Double {
        let tmp = minor(row: row, column: column)
        if ((row + column) % 2) == 1 {
            return -tmp
        } else {
            return tmp
        }
    }

    var determinant: Double {
        var det = 0.0
        let size = self.size
        if size == 2 {
            det = self[0,0]*self[1,1] - self[0,1]*self[1,0]
        } else {
            for column in 0..<size {
                det += self[0, column] * cofactor(row: 0, column: column)
            }
        }
        return det
    }
}

struct Matrix4: Matrix, Equatable {
    var m = [
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0,
    ]

    var size: Int {
        return 4
    }

    subscript(row: Int, column: Int) -> Double {
        return m[4*row + column]
    }

    var transposed: Matrix4 {
        Matrix4(m: [
            m[ 0], m[ 4], m[ 8], m[12],
            m[ 1], m[ 5], m[ 9], m[13],
            m[ 2], m[ 6], m[10], m[14],
            m[ 3], m[ 7], m[11], m[15]
        ])
    }

    var inverse: Matrix4? {
        let d = determinant
        guard d != 0.0 else {
            return nil
        }
        return Matrix4(m: [
            cofactor(row: 0, column: 0)/d, cofactor(row: 1, column: 0)/d, cofactor(row: 2, column: 0)/d, cofactor(row: 3, column: 0)/d,
            cofactor(row: 0, column: 1)/d, cofactor(row: 1, column: 1)/d, cofactor(row: 2, column: 1)/d, cofactor(row: 3, column: 1)/d,
            cofactor(row: 0, column: 2)/d, cofactor(row: 1, column: 2)/d, cofactor(row: 2, column: 2)/d, cofactor(row: 3, column: 2)/d,
            cofactor(row: 0, column: 3)/d, cofactor(row: 1, column: 3)/d, cofactor(row: 2, column: 3)/d, cofactor(row: 3, column: 3)/d,
        ])
    }

    static let identity = Matrix4()

    static func perspective(fov: Double, aspect: Double, near: Double, far: Double) -> Matrix4 {
        let f = 1.0 / tan(fov / 2.0)
        return Matrix4(m: [
            f / aspect, 0.0, 0.0, 0.0,
            0.0, f, 0.0, 0.0,
            0.0, 0.0, (far + near) / (near - far), -1.0,
            0.0, 0.0, (2.0 * far * near) / (near - far), 0.0
        ])
    }

    static func translation(_ v: Vector4) -> Matrix4 {
        Matrix4(m: [
            1.0, 0.0, 0.0, v.x,
            0.0, 1.0, 0.0, v.y,
            0.0, 0.0, 1.0, v.z,
            0.0, 0.0, 0.0, v.w,
        ])
    }

    static func translation(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0) -> Matrix4 {
        Matrix4(m: [
            1.0, 0.0, 0.0, x,
            0.0, 1.0, 0.0, y,
            0.0, 0.0, 1.0, z,
            0.0, 0.0, 0.0, 1.0,
        ])
    }

    func translate(_ v: Vector4) -> Matrix4 {
        .translation(v) * self
    }

    func translate(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0) -> Matrix4 {
        .translation(.point(x: x, y: y, z: z)) * self
    }

    static func scaling(_ v: Vector4) -> Matrix4 {
        Matrix4(m: [
            v.x, 0.0, 0.0, 0.0,
            0.0, v.y, 0.0, 0.0,
            0.0, 0.0, v.z, 0.0,
            0.0, 0.0, 0.0, v.w,
        ])
    }

    func scale(_ v: Vector4) -> Matrix4 {
        .scaling(v) * self
    }

    func scale(x: Double = 1.0, y: Double = 1.0, z: Double = 1.0) -> Matrix4 {
        .scaling(Vector4(x: x, y: y, z: z, w: 1.0)) * self
    }

    static func rotation(angle: Double, v: Vector4) -> Matrix4 {
        let c = cos(angle)
        let ci = 1.0 - c
        let s = sin(angle)

        let xy = v.x * v.y * ci
        let xz = v.x * v.z * ci
        let yz = v.y * v.z * ci
        let xs = v.x * s
        let ys = v.y * s
        let zs = v.z * s

        return Matrix4(m: [
            v.x * v.x * ci + c, xy + zs, xz - ys, 0.0,
            xy - zs, v.y * v.y * ci + c, yz + xs, 0.0,
            xz + ys, yz - xs, v.z * v.z * ci + c, 0.0,
            0.0, 0.0, 0.0, 1.0
        ]).transposed
    }

    func rotate(angle: Double, _ v: Vector4) -> Matrix4 {
        .rotation(angle: angle, v: v) * self
    }

    func rotate(angle: Double, x: Double = 0.0, y: Double = 0.0, z: Double = 0.0) -> Matrix4 {
        .rotation(angle: angle, v: .vector(x: x, y: y, z: z)) * self
    }

    static func shearing(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double) -> Matrix4 {
        Matrix4(m: [
            1, xy, xz, 0,
            yx, 1, yz, 0,
            zx, zy, 1, 0,
            0, 0, 0, 1,
        ])
    }

    func shear(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double) -> Matrix4 {
        .shearing(xy: xy, xz: xz, yx: yx, yz: yz, zx: zx, zy: zy) * self
    }
}

func == (left: Matrix4, right: Matrix4) -> Bool {
    for i in 0..<16 {
        if !left.m[i].roughlyEqual(right.m[i]) {
            return false
        }
    }
    return true
}

func != (left: Matrix4, right: Matrix4) -> Bool {
    return !(left == right)
}

func * (left: Matrix4, right: Matrix4) -> Matrix4 {
    let m1 = left.m
    let m2 = right.m
    return Matrix4(m: [
        m1[ 0]*m2[ 0] + m1[ 1]*m2[ 4] + m1[ 2]*m2[ 8] + m1[ 3]*m2[12],
        m1[ 0]*m2[ 1] + m1[ 1]*m2[ 5] + m1[ 2]*m2[ 9] + m1[ 3]*m2[13],
        m1[ 0]*m2[ 2] + m1[ 1]*m2[ 6] + m1[ 2]*m2[10] + m1[ 3]*m2[14],
        m1[ 0]*m2[ 3] + m1[ 1]*m2[ 7] + m1[ 2]*m2[11] + m1[ 3]*m2[15],
        m1[ 4]*m2[ 0] + m1[ 5]*m2[ 4] + m1[ 6]*m2[ 8] + m1[ 7]*m2[12],
        m1[ 4]*m2[ 1] + m1[ 5]*m2[ 5] + m1[ 6]*m2[ 9] + m1[ 7]*m2[13],
        m1[ 4]*m2[ 2] + m1[ 5]*m2[ 6] + m1[ 6]*m2[10] + m1[ 7]*m2[14],
        m1[ 4]*m2[ 3] + m1[ 5]*m2[ 7] + m1[ 6]*m2[11] + m1[ 7]*m2[15],
        m1[ 8]*m2[ 0] + m1[ 9]*m2[ 4] + m1[10]*m2[ 8] + m1[11]*m2[12],
        m1[ 8]*m2[ 1] + m1[ 9]*m2[ 5] + m1[10]*m2[ 9] + m1[11]*m2[13],
        m1[ 8]*m2[ 2] + m1[ 9]*m2[ 6] + m1[10]*m2[10] + m1[11]*m2[14],
        m1[ 8]*m2[ 3] + m1[ 9]*m2[ 7] + m1[10]*m2[11] + m1[11]*m2[15],
        m1[12]*m2[ 0] + m1[13]*m2[ 4] + m1[14]*m2[ 8] + m1[15]*m2[12],
        m1[12]*m2[ 1] + m1[13]*m2[ 5] + m1[14]*m2[ 9] + m1[15]*m2[13],
        m1[12]*m2[ 2] + m1[13]*m2[ 6] + m1[14]*m2[10] + m1[15]*m2[14],
        m1[12]*m2[ 3] + m1[13]*m2[ 7] + m1[14]*m2[11] + m1[15]*m2[15]
    ])
}

func * (left: Matrix4, right: Vector4) -> Vector4 {
    Vector4(x: left.m[ 0]*right.x + left.m[ 1]*right.y + left.m[ 2]*right.z + left.m[ 3]*right.w,
            y: left.m[ 4]*right.x + left.m[ 5]*right.y + left.m[ 6]*right.z + left.m[ 7]*right.w,
            z: left.m[ 8]*right.x + left.m[ 9]*right.y + left.m[10]*right.z + left.m[11]*right.w,
            w: left.m[12]*right.x + left.m[13]*right.y + left.m[14]*right.z + left.m[15]*right.w)
}
