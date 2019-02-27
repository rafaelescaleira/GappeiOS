//
//  AlertModel.swift
//  Gappe
//
//  Created by Rafael Escaleira on 26/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit

class AlertModel {
    
    static let instance = AlertModel()
    
    func setAlert(title: String, message: String, titleColor: UIColor, style: UIAlertController.Style) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : titleColor])
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        action.setValue(titleColor, forKey: "titleTextColor")
        alert.addAction(action)
        
        return alert
    }
}
