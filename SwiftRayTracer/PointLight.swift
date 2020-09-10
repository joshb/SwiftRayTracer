//
//  PointLight.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/10/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

struct PointLight {
    let position: Vector4
    let color: Color

    init(position: Vector4 = .point(x: 0, y: 0, z: 0), color: Color = .white) {
        self.position = position
        self.color = color
    }

    func lighting(material: Material, position: Vector4, eye: Vector4, normal: Vector4) -> Color {
        let effectiveColor = material.color * self.color
        let ambient = effectiveColor * material.ambient

        let light = (self.position - position).normalized
        let lightDotNormal = light.dotProduct(normal)

        var diffuse = Color.black
        var specular = Color.black
        if lightDotNormal > 0 {
            diffuse = effectiveColor * material.diffuse * lightDotNormal

            let reflect = (light * -1).reflect(n: normal)
            let reflectDotEye = reflect.dotProduct(eye)
            if reflectDotEye > 0 {
                let f = pow(reflectDotEye, material.shininess)
                specular = self.color * material.specular * f
            }
        }

        var result = ambient + diffuse + specular
        result.a = 1.0
        return result
    }
}
