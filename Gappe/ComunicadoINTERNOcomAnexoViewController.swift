//
//  ComunicadoINTERNOcomAnexoViewController.swift
//  Gappe
//
//  Created by Catwork on 06/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class ComunicadoINTERNOcomAnexoViewController: UIViewController {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var linkAnexo: UIButton!

    static var id: Int = Int()
    var comunicadosDados:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkAnexo.layer.cornerRadius = 12
        
        let database = DatabaseModel()
        comunicadosDados = database.selectComunicadoByID(idParam: ComunicadoINTERNOcomAnexoViewController.id)
        
        if comunicadosDados.count > 0 {

            let dadoArray = comunicadosDados.object(at: 0) as! NSArray
            self.titulo.text = dadoArray.object(at: 1) as? String
            self.texto.text = dadoArray.object(at: 2) as? String
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
