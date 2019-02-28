//
//  SynchronizationModel.swift
//  Gappe
//
//  Created by Rafael Escaleira on 26/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import SharkORM

let LINK_GLOBAL = "http://165.227.86.154/api/"
let LINK_COMMUNICATED = LINK_GLOBAL + "comunicados/meus_comunicados/"
let LINK_COMMUNICATED_ANSWER = LINK_GLOBAL + "comunicados/responder"

class SynchronizationModel {
    
    static let instance = SynchronizationModel()
    
    
    func getParametersCommunicatedAnswer(resposta: Int, idCommunicated: Int) -> String {
        
        let parameter = "comunicados_responsavel_id=\(idCommunicated)&resposta=\(resposta)"
        
        return parameter
    }
    
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
    
    func requestCommunicateAnswer(comunicadoSelecionado: ComunicadosDatabase, parameters: String, completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: LINK_COMMUNICATED_ANSWER)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        print(url)
        print(parameters)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            let (success, dataResult, title, message) = self.requestCompletionHandler(data: data, response: response, error: error)
            if success == false { completion(false, title, message); return }
            
            DispatchQueue.global(qos: .background).async {
                
                comunicadoSelecionado.comunicados_resposta = (NSString(data: dataResult, encoding: String.Encoding.utf8.rawValue))!.integerValue
                print((NSString(data: dataResult, encoding: String.Encoding.utf8.rawValue))!.integerValue)
                comunicadoSelecionado.commit()
                
                DispatchQueue.main.async {
                    
                    print("Resposta recebida")
                    completion(true, title, message)
                }
            }
        })
        
        task.resume()
    }
    
    func requestCommunicated(idUser: String, completion: @escaping (Bool, String, String) -> ()) {
        
        let url: URL = URL(string: LINK_COMMUNICATED + idUser + "/" + DatabaseSharkModel.instance.getLastChangeCommunicated())!
        print(url)
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            let (success, dataResult, title, message) = self.requestCompletionHandler(data: data, response: response, error: error)
            
            if success == false { completion(false, title, message); return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: dataResult, options: [])
                if let array = json as? [Any], array.isEmpty == false {
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        for communicate in array {
                            
                            autoreleasepool {
                                
                                guard let userDict = communicate as? [String: Any] else { return }
                                let newData = ComunicadosDatabase()
                                
                                newData.comunicados_id = (userDict["id"] as? NSString)?.integerValue ?? Int.min
                                newData.comunicados_titulo = userDict["titulo"] as? String ?? ""
                                newData.comunicados_texto = userDict["texto"] as? String ?? ""
                                newData.comunicados_data = userDict["data"] as? String ?? ""
                                newData.comunicados_tipo_id = userDict["tipo_id"] as? String ?? ""
                                newData.comunicados_colaborador_id = userDict["colaborador_id"] as? String ?? ""
                                newData.comunicados_situacao = userDict["situacao"] as? String ?? ""
                                newData.comunicados_recebe_resposta = userDict["recebe_resposta"] as? String ?? ""
                                newData.comunicados_mostrar_agenda = userDict["mostrar_agenda"] as? String ?? ""
                                newData.comunicados_criado_em = userDict["criado_em"] as? Int ?? Int.min
                                print(newData.comunicados_criado_em)
                                newData.comunicados_comunicados_responsavel_id = userDict["comunicados_responsavel_id"] as? String ?? ""
                                newData.comunicados_attach = userDict["attach"] as? String ?? ""
                                newData.comunicados_resposta = Int.min
                                
                                newData.commit()
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            print("Finalizado a obtenção de Tipos de Pessoas")
                            completion(true, title, message)
                        }
                    }
                }
                    
                else { return }
            }
                
            catch {}
        }
        
        task.resume()
    }
}
