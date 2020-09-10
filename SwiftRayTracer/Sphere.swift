//
//  Sphere.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

struct Intersection {
    let t: Double
    let object: Sphere
}

class Sphere {
    let transform: Matrix4
    let inverseTransform: Matrix4
    let transposedInverseTransform: Matrix4
    let material: Material

    init(transform: Matrix4, material: Material) {
        self.transform = transform
        self.inverseTransform = transform.inverse!
        self.transposedInverseTransform = inverseTransform.transposed
        self.material = material
    }

    func normalAt(p: Vector4) -> Vector4 {
        let objectPoint = inverseTransform * p
        let objectNormal = objectPoint - .point(x: 0.0, y: 0.0, z: 0.0)
        var worldNormal = transposedInverseTransform * objectNormal
        worldNormal.w = 0
        return worldNormal.normalized
    }

    func intersections(ray originalRay: Ray) -> (Intersection?, Intersection?) {
        let ray = originalRay.transform(m: inverseTransform)
        let sphereToRay = ray.origin - .point(x: 0.0, y: 0.0, z: 0.0)
        let a = ray.direction.dotProduct(ray.direction)
        let b = 2.0 * ray.direction.dotProduct(sphereToRay)
        let c = sphereToRay.dotProduct(sphereToRay) - 1.0
        let discriminant = b*b - 4.0 * a * c
        if discriminant < 0.0 {
            return (nil, nil)
        }

        let sqrtDiscriminant = sqrt(discriminant)
        return (
            Intersection(t: (-b - sqrtDiscriminant) / (2.0 * a), object: self),
            Intersection(t: (-b + sqrtDiscriminant) / (2.0 * a), object: self)
        )
    }
}
