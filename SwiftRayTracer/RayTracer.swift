//
//  RayTracer.swift
//  SwiftRayTracer
//
//  Created by Josh Beam on 9/9/20.
//  Copyright © 2020 Josh Beam. All rights reserved.
//

import Foundation

struct Ray {
    let origin: Vector4
    let direction: Vector4

    func position(t: Double) -> Vector4 {
        origin + direction * t
    }

    func transform(m: Matrix4) -> Ray {
        Ray(origin: m * origin, direction: m * direction)
    }
}

class RayTracer {
    private var _lights: [PointLight]
    private var _objects: [Sphere]
    private var _framebuffer: Framebuffer

    let width, height: Int

    init(width: Int, height: Int, lights: [PointLight], objects: [Sphere]) {
        self.width = width
        self.height = height
        _lights = lights
        _objects = objects
        _framebuffer = Framebuffer(width: width, height: height)
    }

    private func findHit(ray: Ray) -> Intersection? {
        var closest: Intersection?
        func checkIntersection(_ intersection: Intersection?) {
            if let i = intersection {
                if i.t > 0.0 && (closest == nil || i.t < closest!.t) {
                    closest = intersection
                }
            }
        }
        for obj in _objects {
            let (i1, i2) = obj.intersections(ray: ray)
            checkIntersection(i1)
            checkIntersection(i2)
        }
        return closest
    }

    func render(rayOrigin: Vector4) -> CGImage {
        let wallZ = 10.0
        let wallSize = 7.0
        let pixelWidth = wallSize / Double(width)
        let pixelHeight = wallSize / Double(height)
        let half = wallSize / 2.0

        for y in 0..<height {
            let worldY = half - pixelHeight * Double(y)
            for x in 0..<width {
                let worldX = -half + pixelWidth * Double(x)

                let position = Vector4.point(x: worldX, y: worldY, z: wallZ)
                let ray = Ray(origin: rayOrigin, direction: (position - rayOrigin).normalized)
                if let hit = self.findHit(ray: ray) {
                    let hitPoint = ray.position(t: hit.t)
                    let normal = hit.object.normalAt(p: hitPoint)
                    let eye = ray.direction * -1
                    var color = Color.black
                    for light in self._lights {
                        color = color + light.lighting(material: hit.object.material, position: hitPoint, eye: eye, normal: normal)
                    }
                    _framebuffer.setPixel(x: x, y: y, color: color)
                }
            }
        }


        return _framebuffer.image
    }
}
