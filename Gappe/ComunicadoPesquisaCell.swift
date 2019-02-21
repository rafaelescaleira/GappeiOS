//
//  ComunicadoPesquisaCell.swift
//  Gappe
//
//  Created by Catwork on 18/04/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class ComunicadoPesquisaCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var temAnexo: UIImageView!
    @IBOutlet weak var imagem_ic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
