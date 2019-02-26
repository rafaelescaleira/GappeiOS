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
    
    var comunicadosDados: NSMutableArray = NSMutableArray()
    var comunicadoSelecionado = ComunicadosDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = DatabaseModel()
        comunicadosDados = database.selectComunicadoByID(idParam: ComunicadoINTERNOcomAnexoViewController.id)
        print(ComunicadoINTERNOcomAnexoViewController.id)
        
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

extension ComunicadoINTERNOViewController {
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        
        
    }
}

/* Functions */

extension ComunicadoINTERNOViewController {
    
    func requestCompletionHandler(data: Data?, response: URLResponse?, error: Error?) -> (Bool, Data, String, String) {
        
        if error != nil {
            return (false, Data(), "Erro de Conexão ao Servidor", "Ocorreu uma falha na comunicação com o servidor")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return (false, Data(), "Erro de Conexão ao Servidor", "Ocorreu uma falha na comunicação com o servidor")
        }
        
        if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
            return (false, Data(), "Parâmetros Inválidos", "Confira se o aplicativo está atualizado, caso esteja entre em contato")
        }
            
        else if httpResponse.statusCode >= 500 {
            return (false, Data(), "Erro do Servidor", "Não foi possível completar sua solicitação, tente novamente")
        }
        
        guard let dataResult = data else {
            return (false, Data(), "Dados Não Encontrados", "Não existe os dados solicidatos no servidor")
        }
        
        return (true, dataResult, "", "")
    }
    
    func requestAnser(parameters: [String: Any], completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: "http://165.227.86.154/api/comunicados/responder")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        do { request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) }
        catch let error { print(error.localizedDescription) }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            let (success, dataResult, title, message) = self.requestCompletionHandler(data: data, response: response, error: error)
            if success == false { completion(false, title, message); return }
            
            DispatchQueue.global(qos: .background).async {
                
                self.comunicadoSelecionado.comunicados_resposta = Int(String(data: dataResult, encoding: String.Encoding.utf8)!)!
                self.comunicadoSelecionado.commit()
                
                DispatchQueue.main.async {
                    
                    print("Resposta recebida")
                    completion(true, title, message)
                }
            }
        })
        
        task.resume()
    }
}
