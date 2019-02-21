//
//  PerfilViewController.swift
//  Gappe
//
//  Created by Catwork on 12/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var imagemPerfil: UIImageView!
    @IBOutlet weak var nomeCompleto: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telefone: UILabel!
    
    var perfilObject:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if let imgData = UserDefaults.standard.object(forKey: "myImageKey") as? NSData {
            let retrievedImg = UIImage(data: imgData as Data)
            imagemPerfil.image = retrievedImg
        }
        
        imagemPerfil.layer.cornerRadius = imagemPerfil.frame.size.height/2
        imagemPerfil.layer.borderWidth = 5
        imagemPerfil.layer.borderColor = UIColor.blue.cgColor
        imagemPerfil.clipsToBounds = true
        
        self.nomeCompleto.text = UserDefaults.standard.object(forKey: "nome") as? String
        self.email.text = UserDefaults.standard.object(forKey: "email") as? String
        self.telefone.text = UserDefaults.standard.object(forKey: "telefone") as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
