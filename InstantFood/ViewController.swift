//
//  ViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 05/04/2024.
//

import UIKit

class ViewController: UIViewController {

    var shape : CAShapeLayer?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shape?.removeFromSuperlayer()
        drawBottomLayer()
        
    }

    func drawBottomLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(named: "Brown")?.cgColor
        
        let path = UIBezierPath()
        let rect = UIScreen.main.bounds
        let width = rect.width
        let height = rect.height
    
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height - 300))
        
        path.addCurve(to: CGPoint(x: width - 195, y: height - 160),
                      controlPoint1: CGPoint(x: width - 30, y: height - 174),
                      controlPoint2: CGPoint(x: width - 190, y: height - 160))
        path.addCurve(to: CGPoint(x: 0, y: height),
                      controlPoint1: CGPoint(x: width - 220, y: height - 160 ),
                      controlPoint2: CGPoint(x: width - 370, y: height - 150 ))
        
        path.close()
        
        shapeLayer.path = path.cgPath
        self.view.layer.addSublayer(shapeLayer)
        self.shape = shapeLayer
        
    }

}

