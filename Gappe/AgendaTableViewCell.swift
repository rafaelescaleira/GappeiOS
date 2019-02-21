//
//  AgendaTableViewCell.swift
//  Gappe
//
//  Created by Catwork on 23/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
