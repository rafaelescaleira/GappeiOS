//
//  ForcarTrocarSenhaViewController.swift
//  Gappe
//
//  Created by Catwork on 02/05/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class ForcarTrocarSenhaViewController: UIViewController {

    @IBOutlet weak var senhaAntiga: UITextField!
    @IBOutlet weak var novaSenha: UITextField!
    @IBOutlet weak var repetirSenha: UITextField!
    @IBOutlet weak var labelValidacao: UILabel!
    @IBOutlet weak var enviarBtn: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Back", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func enviar(_ sender: UIButton) {
        if senhaAntiga.text != "" && novaSenha.text != "" && repetirSenha.text != ""{
            if novaSenha.text == repetirSenha.text {
                trocarSenha(senhaAntiga: senhaAntiga.text!, senhaNova: novaSenha.text!)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "InitialView") as! SWRevealViewController
                self.present(viewController, animated: true, completion: nil)
            } else {
                labelValidacao.text = "Senha repetida não confere."
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backImage.image = .fontAwesomeIcon(name: .chevronLeft, style: .solid, textColor: .white, size: self.backImage.bounds.size)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TelaLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func trocarSenha(senhaAntiga: String, senhaNova: String) {
        
        let id_user = UserDefaults.standard.object(forKey: "id_user") as! String
        let database = DatabaseModel()
        let url = URL(string: "\(database.getURLBase())/api/users/\(id_user)")
        
        let request = NSMutableURLRequest(url: url!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        //print("id=\(id_user)&antiga=\(senhaAntiga)&nova=\(senhaNova)")
        let data = "id=\(id_user)&antiga=\(senhaAntiga)&nova=\(senhaNova)".data(using: String.Encoding.utf8)
        
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print("erro ao trocar senha")
            }
            else {
                //let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()
        
    }

}




