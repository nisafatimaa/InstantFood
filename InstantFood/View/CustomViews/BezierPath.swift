//
//  BezierPath.swift
//  InstantFood
//
//  Created by Macbook Pro on 15/04/2024.
//

import UIKit

struct BezierPath {
    
    //static: type function(which can be used without creating instance of its struct)
    static func createPath(in frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let width = frame.width
        let height = frame.height

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height - 282))

        path.addCurve(to: CGPoint(x: width - 195, y: height - 160),
                      controlPoint1: CGPoint(x: width - 30, y: height - 174),
                      controlPoint2: CGPoint(x: width - 190, y: height - 160))
        path.addCurve(to: CGPoint(x: 0, y: height),
                      controlPoint1: CGPoint(x: width - 220, y: height - 160 ),
                      controlPoint2: CGPoint(x: width - 370, y: height - 150 ))

        path.close()
        return path
      }
}
