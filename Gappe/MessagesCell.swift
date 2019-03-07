//
//  MessagesCell.swift
//  Gappe
//
//  Created by Lucas Avila on 06/06/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var leftViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }    
}
