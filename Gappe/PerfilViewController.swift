//
//  PerfilViewController.swift
//  Gappe
//
//  Created by Catwork on 12/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var imagemPerfil: UIImageView!
    @IBOutlet weak var nomeCompleto: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telefone: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    var perfilObject:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        if let imgData = UserDefaults.standard.object(forKey: "myImageKey") as? NSData {
            let retrievedImg = UIImage(data: imgData as Data)
            imagemPerfil.image = retrievedImg
        }
        
        imagemPerfil.layer.cornerRadius = 15
        
        self.nomeCompleto.text = UserDefaults.standard.object(forKey: "nome") as? String
        self.email.text = UserDefaults.standard.object(forKey: "email") as? String
        self.telefone.text = UserDefaults.standard.object(forKey: "telefone") as? String
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBAction func unwindFromPerfil(unwindSegue: UIStoryboardSegue) {  }
}
