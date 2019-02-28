//
//  MenuViewController.swift
//  Gappe
//
//  Created by Catwork on 27/02/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var imagemPerfil: UIImageView!
    
    let database = DatabaseModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagemPerfil.layer.cornerRadius = imagemPerfil.frame.size.height/2
        imagemPerfil.clipsToBounds = true
        
        self.nome.text = UserDefaults.standard.object(forKey: "nome") as? String
        self.email.text = UserDefaults.standard.object(forKey: "email") as? String
    }

    override func viewWillAppear(_ animated: Bool) {
        if let imgData = UserDefaults.standard.object(forKey: "myImageKey") as? NSData {
            let retrievedImg = UIImage(data: imgData as Data)
            imagemPerfil.image = retrievedImg
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            UserDefaults.standard.removeObject(forKey: "logado")
            UserDefaults.standard.removeObject(forKey: "id_user")
            UserDefaults.standard.removeObject(forKey: "device_token")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "foto")
            UserDefaults.standard.removeObject(forKey: "nome")
            UserDefaults.standard.removeObject(forKey: "telefone")
            UserDefaults.standard.synchronize()
            
            SharkORM.rawQuery("DELETE FROM ComunicadosDatabase")
            
            database.deletaBanco()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuComunicados", for: indexPath) as! MenuComunicadosCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuAgenda", for: indexPath) as! MenuAgendaCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuMensagens", for: indexPath) as! MenuMensagensCell
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuPerfil", for: indexPath) as! MenuPerfilCell
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuEscola", for: indexPath) as! MenuEscolaCell
            return cell
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSobre", for: indexPath) as! MenuSobreCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSair", for: indexPath) as! MenuSairCell
            return cell
        }
    }

}





