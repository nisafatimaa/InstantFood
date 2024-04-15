//
//  ViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 05/04/2024.
//

import UIKit

class ViewController: UIViewController {

    var shape : CAShapeLayer?
    
    //it will be called whenever layout changer
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shape?.removeFromSuperlayer()
        drawBottomLayer()
        
    }

    func drawBottomLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(named: "Brown")?.cgColor
        shapeLayer.path = BezierPath.createPath(in: view.frame).cgPath
        self.view.layer.addSublayer(shapeLayer)
        self.shape = shapeLayer
        
    }
}

