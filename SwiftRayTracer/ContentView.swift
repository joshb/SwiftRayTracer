//
//  ContentView.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let size = 640
        let rayTracer = RayTracer(
            width: size,
            height: size,
            lights: [
                PointLight(position: .point(x: -5, y: 5, z: 5), color: .white),
                PointLight(position: .point(x: 5, y: 5, z: -5), color: .white)
            ],
            objects: [
                Sphere(
                    transform: .translation(x: -1, y: 1, z: 2.5),
                    material: Material(color: .blue, shininess: 100)
                ),
                Sphere(
                    transform: .translation(x: 0.75, y: -0.75),
                    material: Material(color: .green)
                ),
            ]
        )

        let image = rayTracer.render(rayOrigin: .point(x: 0.0, y: 0.0, z: -15.0))
        return Image(decorative: image, scale: 1.0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
