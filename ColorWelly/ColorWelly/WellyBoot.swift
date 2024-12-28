//
//  WellyBoot.swift
//  ColorWelly
//
//  Created by Andrew Dent on 25/12/2024.
//

import SwiftUI

struct WellyBoot: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let bootLeft = width * 0.2
        let heelRight = width * 0.4
        let shaftRight = width * 0.6
        let ankleRight = width * 0.78
        let toeStart = width * 0.8
        let toeRight = width * 0.9

        let topBoot = height * 0.2
        let topAnkle = height * 0.6
        let topFoot = height * 0.7
        let bottomAnkle = height * 0.72
        let sole = height * 0.85
        let heelTop = height * 0.82

        // start at sole, toe, iterating around clockwise
        path.move(to: CGPoint(x: toeRight, y: sole))
        path.addLine(to: CGPoint(x: shaftRight, y: sole))
        path.addLine(to: CGPoint(x: heelRight, y: heelTop))
        path.addLine(to: CGPoint(x: heelRight, y: sole))
        path.addLine(to: CGPoint(x: bootLeft, y: sole))
        path.addLine(to: CGPoint(x: bootLeft, y: topBoot))
        
        path.addLine(to: CGPoint(x: shaftRight, y: topBoot))
        
        // Down the front side of the boot shaft
        path.addLine(to: CGPoint(x: shaftRight, y: topAnkle))
        
        // Curve outward for the ankle section
        path.addQuadCurve(to: CGPoint(x: ankleRight, y: bottomAnkle),
                          control: CGPoint(x: width * 0.55, y: height * 0.7))
        
        path.addLine(to: CGPoint(x: toeStart, y: bottomAnkle))

        // Front toe area
        path.addQuadCurve(to: CGPoint(x: toeRight, y: sole),
                          control: CGPoint(x: width * 0.95, y: height * 0.78))
        return path
    }
}
