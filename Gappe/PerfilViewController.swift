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
    
    var user = UserDatabase.query().fetch().firstObject as? UserDatabase ?? UserDatabase()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        imagemPerfil.layer.cornerRadius = 15
        
        self.imagemPerfil.image = UIImage(data: self.user.user_foto)
        self.nomeCompleto.text = self.user.user_nome.lowercased().capitalized
        self.email.text = self.user.user_email
        self.telefone.text = self.user.user_telefone
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBAction func unwindFromPerfil(unwindSegue: UIStoryboardSegue) {
        
        self.user = UserDatabase.query().fetch().firstObject as? UserDatabase ?? UserDatabase()
        self.imagemPerfil.image = UIImage(data: self.user.user_foto)
        self.nomeCompleto.text = self.user.user_nome.lowercased().capitalized
        self.email.text = self.user.user_email
        self.telefone.text = self.user.user_telefone
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vcDestino = segue.destination as? EdicaoPerfilViewController else { return }
        vcDestino.user = self.user
    }
}
