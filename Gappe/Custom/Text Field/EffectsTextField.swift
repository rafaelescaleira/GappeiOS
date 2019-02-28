//
//  EffectsTextField.swift
//  iChat
//
//  Created by Rafael Escaleira on 26/07/18.
//  Copyright © 2018 Rafael Escaleira. All rights reserved.
//

import UIKit

extension String {
    
    var isNotEmpty: Bool {
        
        return !isEmpty
        
    }
    
}

open class TextFieldEffects : UITextField {
    
    public enum AnimationType: Int {
        
        case textEntry
        case textDisplay
        
    }
    
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    public let placeholderLabel = UILabel()
    public let imagePlaceholder = UIImageView()
    
    open func animateViewsForTextEntry() {
        
        fatalError("\(#function) must be overridden")
        
    }
    
    open func animateViewsForTextDisplay() {
        
        fatalError("\(#function) must be overridden")
        
    }
    
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    open func drawViewsForRect(_ rect: CGRect) {
        
        fatalError("\(#function) must be overridden")
        
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        
        fatalError("\(#function) must be overridden")
        
    }
    
    override open func draw(_ rect: CGRect) {
        
        guard isFirstResponder == false else { return }
        drawViewsForRect(rect)
        
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        
    }
    
    override open var text: String? {
        
        didSet {
            
            if let text = text, text.isNotEmpty {
                
                animateViewsForTextEntry()
                
            }
            
            else {
                
                animateViewsForTextDisplay()
                
            }
            
        }
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        
        if newSuperview != nil {
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
            
        }
        
        else {
            
            NotificationCenter.default.removeObserver(self)
            
        }
        
    }
    
    @objc open func textFieldDidBeginEditing() {
        
        animateViewsForTextEntry()
        
    }
    
    @objc open func textFieldDidEndEditing() {
        
        animateViewsForTextDisplay()
        
    }
    
    override open func prepareForInterfaceBuilder() {
        
        drawViewsForRect(frame)
        
    }
    
}
