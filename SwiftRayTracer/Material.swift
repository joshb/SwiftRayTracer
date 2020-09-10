//
//  Material.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/10/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

struct Material {
    var color: Color
    var ambient, diffuse, specular, shininess: Double

    init(color: Color = .white, ambient: Double = 0.1, diffuse: Double = 0.8, specular: Double = 0.8, shininess: Double = 100.0) {
        self.color = color
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.shininess = shininess
    }
}
