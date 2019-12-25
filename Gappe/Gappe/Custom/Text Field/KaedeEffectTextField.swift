//
//  KaedeEffectTextField.swift
//  iChat
//
//  Created by Rafael Escaleira on 26/07/18.
//  Copyright © 2018 Rafael Escaleira. All rights reserved.
//

import UIKit

@IBDesignable open class KaedeTextField: TextFieldEffects {
    
    @IBInspectable dynamic open var ImagePlacehoder: UIImage? = nil {
        
        didSet {
            
            updatePlaceholder()
            
        }
        
    }
    
    @IBInspectable var Padding : CGFloat = 12 {
        
        didSet {
            
            updatePlaceholder()
            
        }
        
    }
    
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.8 {
        
        didSet {
            
            updatePlaceholder()
            
        }
        
    }
    
    override open var bounds: CGRect {
        
        didSet {
            
            drawViewsForRect(bounds)
            
        }
        
    }
    
    private let foregroundView = UIView()
    private let placeholderInsets = CGPoint(x: 10, y: 12)
    private let textFieldInsets = CGPoint(x: 10, y: 12)
    
    override open func drawViewsForRect(_ rect: CGRect) {
        
        let frame = CGRect(origin: .zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        foregroundView.frame = frame
        foregroundView.isUserInteractionEnabled = false
        
        if ImagePlacehoder != nil {
            
            imagePlaceholder.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
            placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x + 40, dy: placeholderInsets.y)
            
        }
        
        else {
            
            placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
            
        }
        
        updatePlaceholder()
        
        if text!.isNotEmpty || isFirstResponder {
            
            animateViewsForTextEntry()
            
        }
        
        addSubview(foregroundView)
        addSubview(placeholderLabel)
        
        if ImagePlacehoder != nil {
            
            addSubview(imagePlaceholder)
            
        }
        
    }
    
    override open func animateViewsForTextEntry() {
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
            
            if self.ImagePlacehoder != nil {
                
                self.imagePlaceholder.frame.origin = CGPoint(x: ((self.frame.size.width) - (self.imagePlaceholder.frame.width + 10)), y: self.Padding)
                self.placeholderLabel.frame.origin = CGPoint(x: (self.frame.size.width), y: self.Padding)
                
            }
            
            else {
                
                self.placeholderLabel.frame.origin = CGPoint(x: (self.frame.size.width * 0.65), y: self.Padding)
                
            }
            
        }), completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .beginFromCurrentState, animations: ({
            self.foregroundView.frame.origin = CGPoint(x: ((self.frame.size.width) - (self.imagePlaceholder.frame.width + 10)), y: 0)
        }), completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
        
    }
    
    override open func animateViewsForTextDisplay() {
        
        if text!.isEmpty {
            
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                
                if self.ImagePlacehoder != nil {
                    
                    self.imagePlaceholder.frame.origin = self.placeholderInsets
                    self.placeholderLabel.frame.origin = CGPoint(x: self.imagePlaceholder.frame.width + 20, y: self.placeholderInsets.y)
                    
                }
                
                else {
                    
                    self.placeholderLabel.frame.origin = self.placeholderInsets
                    
                }
                
            }), completion: nil)
            
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.foregroundView.frame.origin = CGPoint.zero
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            self.placeholderLabel.text = self.placeholder
            
        }
        
    }
    
    private func updatePlaceholder() {
        
        if ImagePlacehoder != nil {
            
            imagePlaceholder.frame = CGRect(x: Padding, y: Padding, width: 30, height: 30)
            imagePlaceholder.image = ImagePlacehoder
            
        }
        
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont(name: "Avenir Next", size: 18)
        placeholderLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
        
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        var frame = CGRect(origin: bounds.origin, size: CGSize(width: ((self.frame.size.width) - (self.imagePlaceholder.frame.width + 5)), height: bounds.size.height))
        
        if #available(iOS 9.0, *) {
            
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
                
                frame.origin = CGPoint(x: bounds.size.width - frame.size.width, y: frame.origin.y)
                
            }
            
        }
        
        return frame.insetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
        
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return editingRect(forBounds: bounds)
        
    }
    
}
