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

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    static var id: Int = Int()
    var comunicadosDados:NSMutableArray = NSMutableArray()
    var comunicadoSelecionado = ComunicadosDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkAnexo.layer.cornerRadius = 12
        
        let database = DatabaseModel()
        comunicadosDados = database.selectComunicadoByID(idParam: ComunicadoINTERNOcomAnexoViewController.id)
        
        if comunicadosDados.count > 0 {

            let dadoArray = comunicadosDados.object(at: 0) as! NSArray
            self.titulo.text = dadoArray.object(at: 1) as? String
            self.texto.text = dadoArray.object(at: 2) as? String
            
            if comunicadoSelecionado.comunicados_recebe_resposta == "0" {
                yesButton.alpha = 0
                noButton.alpha = 0
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

/* Actions */

extension ComunicadoINTERNOcomAnexoViewController {
    
    @IBAction func yesButtonPressed(_ sender: Any) {
    }
    @IBAction func noButtonPressed(_ sender: Any) {
    }
}
