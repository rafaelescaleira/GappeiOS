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
let LINK_LOGIN = LINK_GLOBAL + "users/login"
let LINK_UPLOAD_PERFIL = LINK_GLOBAL + "users/"
let LINK_PROFILE_IMAGE = LINK_GLOBAL + "users/"
let LINK_MENSAGEN = LINK_GLOBAL + "escola_mensagens/sync/"

class SynchronizationModel {
    
    static let instance = SynchronizationModel()
    
    
    func getParametersCommunicatedAnswer(resposta: Int, idCommunicated: Int) -> String {
        
        let parameter = "comunicados_responsavel_id=\(idCommunicated)&resposta=\(resposta)"
        
        return parameter
    }
    
    func getParametersLogin(email: String, senha: String) -> String {
        
        let parameter = "email=\(email)&senha=\(senha)"
        
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
    
    func requestCommunicateAnswer(parameters: String, completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: LINK_COMMUNICATED_ANSWER)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            let (success, dataResult, title, message) = self.requestCompletionHandler(data: data, response: response, error: error)
            if success == false { completion(false, title, message); return }
            
            DispatchQueue.global(qos: .background).async {
                
                let answer = (NSString(data: dataResult, encoding: String.Encoding.utf8.rawValue))!.integerValue
                
                DispatchQueue.main.async {
                    
                    print("Resposta recebida")
                    
                    if answer == -1 {
                        
                        completion(false, "Erro ao Salvar", "Não foi possível salvar sua resposta no servidor, tente mais tarde")
                    }
                    
                    else {
                        
                        completion(true, title, message)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func requestCommunicated(userID: String, completion: @escaping (Bool, String, String) -> ()) {
        
        let url: URL = URL(string: LINK_COMMUNICATED + userID + "/" + DatabaseSharkModel.instance.getLastChangeCommunicated())!
        let session = URLSession.shared
        print(url)
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
                                newData.comunicados_comunicados_responsavel_id = userDict["comunicados_responsavel_id"] as? String ?? ""
                                
                                let links = userDict["attach"] as? [String] ?? []
                                
                                for link in links {
                                    
                                    newData.comunicados_attach = link.components(separatedBy: ";")
                                }
                                
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
    
    func requestLogin(parameters: String, completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: LINK_LOGIN)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            let (success, dataResult, title, message) = self.requestCompletionHandler(data: data, response: response, error: error)
            if success == false { completion(false, title, message); return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: dataResult, options: [])
                guard let userDict = json as? [String: Any] else { return }
                
                DispatchQueue.global(qos: .background).async {
                    
                    let newData = UserDatabase()
                    
                    newData.user_id = (userDict["id"] as! NSString).integerValue
                    newData.user_nome = userDict["nome"] as? String ?? ""
                    newData.user_telefone = userDict["telefone"] as? String ?? ""
                    newData.user_email = userDict["email"] as? String ?? ""
                    newData.user_device_token = userDict["device_token"] as? String ?? ""
                    newData.user_trocar_senha = userDict["trocar_senha"] as? Bool ?? false
                    newData.user_isLogin = true
                    
                    DispatchQueue.main.async {
                        
                        print("Login Efetuado Com Sucesso")
                        
                        SynchronizationModel.instance.requestProfileImage(user: newData, completion: { (s, t, m) in
                            
                            if !s {
                                
                                DispatchQueue.main.async {
                                    
                                    let image = UIImage(named: "default-user-image")!
                                    newData.user_foto = UIImageJPEGRepresentation(image, 1.0)!
                                    newData.commit()
                                    completion(true, "", "")
                                }
                            }
                            
                            else {
                                
                                DispatchQueue.main.async {
                                    
                                    completion(true, "", "")
                                }
                            }
                        })
                    }
                }
            }
                
            catch {}
        })
        
        task.resume()
    }
    
    func requestUploadProfile(user: UserDatabase, completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: LINK_UPLOAD_PERFIL + "\(user.user_id)")!
        
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        let data = "id=\(user.user_id)&nome=\(user.user_nome)&email=\(user.user_email)&telefone=\(user.user_email)".data(using: String.Encoding.utf8)
        
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    
                    completion(false, "Falha ao Enviar Dados", "Verifique se a aplicação está atualizada")
                }
            }
                
            else {
                
                DispatchQueue.main.async {
                    
                    user.commit()
                    completion(true, "Sucesso ao Salvar", "Os dados foram salvos com sucesso")
                }
            }
        }
        
        dataTask.resume()
    }
    
    func requestChangePassword(userID: Int, senhaAntiga: String, senhaNova: String, completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: LINK_UPLOAD_PERFIL + "\(userID)")!
        
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        let data = "id=\(userID)&antiga=\(senhaAntiga)&nova=\(senhaNova)".data(using: String.Encoding.utf8)
        
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    
                    completion(false, "Erro ao Trocar Senha", "Não foi possível trocar sua senha")
                }
            }
                
            else {
                
                DispatchQueue.main.async {
                    
                    completion(false, "Sucesso ao Trocar Senha", "Sua senha foi alterada com sucesso")
                }
            }
        }
        
        dataTask.resume()
        
    }
    
    func requestProfileImage(user: UserDatabase, completion: @escaping (Bool, String, String) -> ()) {
        
        let url: URL = URL(string: LINK_PROFILE_IMAGE + "\(user.user_id)" + "/foto")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        let headers = ["Accept": "image/jpeg"]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.global(qos: .background).async {
                
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil
                    else { completion(false, "", ""); return }
                user.user_foto = data
                user.commit()
                
                DispatchQueue.main.async {
                    
                    print("Finalizado a obtenção de Imagens")
                    completion(true, "", "")
                }
            }
                
        }
        
        task.resume()
    }
    
    
    
}
