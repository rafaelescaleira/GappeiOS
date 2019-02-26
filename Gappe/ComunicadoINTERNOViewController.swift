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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = DatabaseModel()
        comunicadosDados = database.selectComunicadoByID(idParam: ComunicadoINTERNOcomAnexoViewController.id)
        print(ComunicadoINTERNOcomAnexoViewController.id)
        
        if comunicadosDados.count > 0 {
            
            let dadoArray = comunicadosDados.object(at: 0) as! NSArray
            self.titulo.text = dadoArray.object(at: 1) as? String
            self.texto.text = dadoArray.object(at: 2) as? String
            
            if 
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
    
    /*func requestAnser(parameters: [String: Any]) {
        
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
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: dataResult, options: [])
                
                if let array = json as? [String: Any], array.isEmpty == false {
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        let lastChange = array["lastChange"] as? String ?? ""
                        guard let changes = array["changes"] as? [Any] else { return }
                        var index: Int = 0
                        
                        for data in changes {
                            
                            autoreleasepool {
                                
                                guard let userDict = data as? [String: Any] else { return }
                                var newData = CostCenterDatabase()
                                
                                if database == [] {
                                    
                                    newData = CostCenterDatabase()
                                    let newID = DatabaseModel.instance.getNewID(objectID: .costCenter_id, fromTable: .CostCenterDatabase)
                                    newData.costCenter_id = newID == Int.min ? 1 : newID + 1
                                }
                                    
                                else { newData = database[index] }
                                
                                newData.costCenter_cloudId = userDict["id"] as? Int ?? Int.min
                                newData.costCenter_name = userDict["title"] as? String ?? ""
                                //ATIVO
                                newData.costCenter_isUpdate = true
                                newData.costCenter_update = lastChange
                                newData.commit()
                                
                                index = index + 1
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            print("Sincronização de Centros de Custo Finalizada")
                            completion(true, title, message)
                        }
                    }
                }
                    
                else { return }
            }
                
            catch {}
        })
        
        task.resume()
    }*/
}
