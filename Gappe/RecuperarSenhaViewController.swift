//
//  RecuperarSenhaViewController.swift
//  Gappe
//
//  Created by Catwork on 25/04/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class RecuperarSenhaViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var enviarBtn: UIButton!
    @IBOutlet weak var labelValidacao: UILabel!
    
    @IBAction func enviarAction(_ sender: UIButton) {
        recuperarSenha()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Back", sender: nil)
    }
    
    let database = DatabaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TelaLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func recuperarSenha()
    {
        let url = URL(string: "\(database.getURLBase())/api/users/forgot")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let paramToSend = "email=" + email.text!
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                
                DispatchQueue.global(qos: .background).async {
                    
                    guard let data = data else { return }
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("***************")
                        print(json)
                    }
                    
                    catch {
                        
                        print("Não retorna nada")
                        return
                    }
                }
                
                DispatchQueue.main.async() {
                    
                    self.labelValidacao.text = "Um E-mail com uma nova senha foi enviado."
                }
            }
                
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {
                
                DispatchQueue.main.async() {
                    
                    self.labelValidacao.text = "E-mail não encontrado nos cadastros."
                }
            }
        })
        
        task.resume()
    }
}
