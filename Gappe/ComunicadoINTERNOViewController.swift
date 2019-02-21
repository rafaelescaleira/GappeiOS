//
//  ComunicadoINTERNOViewController.swift
//  Gappe
//
//  Created by Catwork on 06/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class ComunicadoINTERNOViewController: UIViewController {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UITextView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    var comunicadosDados:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = DatabaseModel()
        comunicadosDados = database.selectComunicadoByID(idParam: ComunicadoINTERNOcomAnexoViewController.id)
        print(ComunicadoINTERNOcomAnexoViewController.id)
        
        if comunicadosDados.count > 0 {
            
            let dadoArray = comunicadosDados.object(at: 0) as! NSArray
            self.titulo.text = dadoArray.object(at: 1) as? String
            self.texto.text = dadoArray.object(at: 2) as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

/* Actions */

extension ComunicadoINTERNOViewController {
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        
        
    }
}

/* Functions */

extension ComunicadoINTERNOViewController {

    func requestAnser(parameters: [String: Any]) {
        
        
    }
}
