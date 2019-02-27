//
//  CustomNavigationView.swift
//  Gerbov
//
//  Created by Rafael Escaleira on 11/01/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit
@IBDesignable

class CustomNavigationView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var firstColor: UIColor = #colorLiteral(red: 0.130926609, green: 0.3638376892, blue: 0.1635576487, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var secondColor: UIColor = #colorLiteral(red: 0.1278472245, green: 0.446238637, blue: 0.2770447135, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = .init(x: 0, y: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = .init(x: 1, y: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.gradientLayer.startPoint = startPoint
        self.gradientLayer.endPoint = endPoint
        self.layer.cornerRadius = cornerRadius
        
    }
}
