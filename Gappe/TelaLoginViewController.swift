//
//  TelaLoginViewController.swift
//  Gappe
//
//  Created by Catwork on 14/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class TelaLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Login: UITextField!
    @IBOutlet weak var Senha: UITextField!
    @IBOutlet weak var SalvarBtn: UIButton!
    @IBOutlet weak var labelValidacao: UILabel!
    let database = DatabaseModel()
    var comunicadosObject:NSMutableArray = NSMutableArray()
    var mensagensObject:NSMutableArray = NSMutableArray()
    
    @IBAction func SalvarAction(_ sender: UIButton) {
        let login = Login.text!
        let senha = Senha.text!
        
        if (login == "" || senha == ""){
            self.labelValidacao.text = "Um ou mais campos vazios."
            return
        }
        
        SynchronizationModel.instance.requestLogin(parameters: SynchronizationModel.instance.getParametersLogin(email: login, senha: senha)) { (success, title, message) in
            
            if !success {
                
                self.present(AlertModel.instance.setAlert(title: title, message: message, titleColor: #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1), style: .alert), animated: true, completion: nil)
            }
            
            else {
                
                self.DoLogin(login, senha)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SalvarBtn.layer.shadowColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)
        SalvarBtn.layer.shadowRadius = 4.0
        SalvarBtn.layer.shadowOpacity = 0.9
        SalvarBtn.layer.shadowOffset = .zero
        SalvarBtn.layer.masksToBounds = false
        
        let rectShapeEmail = CAShapeLayer()
        let rectShapePassword = CAShapeLayer()
        
        self.Login.delegate = self
        self.Senha.delegate = self
        
        rectShapeEmail.bounds = self.Login.frame
        rectShapeEmail.position = self.Login.center
        rectShapeEmail.path = UIBezierPath(roundedRect: self.Login.bounds, byRoundingCorners: [.topLeft, .topRight] , cornerRadii: CGSize(width: 10, height: 10)).cgPath
        
        rectShapePassword.bounds = self.Senha.frame
        rectShapePassword.position = self.Senha.center
        rectShapePassword.path = UIBezierPath(roundedRect: self.Senha.bounds, byRoundingCorners: [.bottomLeft, .bottomRight] , cornerRadii: CGSize(width: 10, height: 10)).cgPath
        
        self.Login.clipsToBounds = true
        self.Login.layer.mask = rectShapeEmail
        
        self.Senha.clipsToBounds = true
        self.Senha.layer.mask = rectShapePassword
        
        let logado: String = (UserDefaults.standard.object(forKey: "logado") as? String ?? "")!
        if logado == "yes" {
            UserDefaults.standard.removeObject(forKey: "logado")
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TelaLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func DoLogin(_ user:String, _ psw:String)
    {
        let url = URL(string: "\(database.getURLBase())/api/users/login")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let paramToSend = "email=" + user + "&senha=" + psw
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                
                guard let _:Data = data else {
                    return
                }
                
                let json:Any?
                
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                } catch {
                    return
                }
                
                guard let server_response = json as? NSDictionary else {
                    return
                }
                //print(server_response)
                UserDefaults.standard.set("yes", forKey: "logado")
                UserDefaults.standard.set(server_response["id"] as! String, forKey: "id_user")
                UserDefaults.standard.set(server_response["email"] as? String ?? "", forKey: "email")
                UserDefaults.standard.set(server_response["foto"] as? String ?? "", forKey: "foto")
                UserDefaults.standard.set(server_response["nome"] as! String, forKey: "nome")
                UserDefaults.standard.set(server_response["telefone"] as? String ?? "", forKey: "telefone")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async() {
                    self.getComunicadosEMensagens()
                    self.database.enviaToken()
                    
                    let when = DispatchTime.now() + 2.5
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.database.configuraBancoInicial(dadosComunicados: self.comunicadosObject, dadosMensagens: self.mensagensObject)
                    }
                    
                    if server_response["trocar_senha"] as! Bool == false {
                        self.performSegue(withIdentifier: "loginAutorizado", sender: nil)
                    } else if server_response["trocar_senha"] as! Bool == true {
                        self.performSegue(withIdentifier: "trocarSenhaSegue", sender: nil)
                    }
                }
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {
                DispatchQueue.main.async() {
                    self.labelValidacao.text = "Login ou Senha inválidos."
                }
            }
            
        })
        
        task.resume()
    }
    

    func getComunicadosEMensagens() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let id_user = UserDefaults.standard.object(forKey: "id_user") as! String
        let UrlApiComunicados = "\(database.getURLBase())/api/comunicados/meus_comunicados/\(id_user)/0"
        
        if let url = NSURL(string: UrlApiComunicados) {
            
            session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("Erro ao conectar com o servidor.")
                }
                else{
                    let dados:NSData = NSData(data: data!)
                    do {
                        let JsonWithData:AnyObject! = try! JSONSerialization.jsonObject(with: dados as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //print(JsonWithData)
                        let comunicados: NSMutableArray = NSMutableArray()
                        if let todosEventos = JsonWithData! as? NSArray {
                            
                            let contador = todosEventos.count
                            if contador > 0 {
                                for i in 0...contador-1 {
                                    
                                    autoreleasepool {
                                        
                                        let resultado = todosEventos[i] as? NSDictionary
                                        
                                        let id: Int = Int(resultado!["id"] as! String)!
                                        let titulo: String = resultado!["titulo"] as? String ?? ""
                                        let tipo_id: String = resultado!["tipo_id"] as? String ?? ""
                                        let texto: String = resultado!["texto"] as? String ?? ""
                                        let situacao: String = resultado!["situacao"] as? String ?? ""
                                        let recebe_resposta: String = resultado!["recebe_resposta"] as? String ?? ""
                                        let mostrar_agenda: String = resultado!["mostrar_agenda"] as? String ?? ""
                                        let data: String = resultado!["data"] as? String ?? ""
                                        let criado_em: String = resultado!["criado_em"] as? String ?? ""
                                        let comunicados_responsavel_id: String = resultado!["comunicados_responsavel_id"] as? String ?? ""
                                        let colaborador_id: String = resultado!["colaborador_id"] as? String ?? ""
                                        let attach: String = resultado!["attach"] as? String ?? ""
                                    
                                        
                                        let tudo : NSArray = NSArray(objects: id, titulo, tipo_id, texto, situacao, recebe_resposta, mostrar_agenda, data, criado_em, comunicados_responsavel_id, colaborador_id, attach)
                                        comunicados.add(tudo)
                                    }
                                }
                            }
                            
                        }
                        DispatchQueue.main.async() {
                            self.comunicadosObject = comunicados
                        }
                    }
                }
            }).resume()
        }
        
        let UrlApiMensagens = NSURL(string:"\(database.getURLBase())/api/escola_mensagens/sync/\(id_user)/0")
        print(UrlApiMensagens)
        let request = NSMutableURLRequest(url: UrlApiMensagens! as URL)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Erro ao conectar com o servidor.")
            }
            else {
                let dados:NSData = NSData(data: data!)
                do {
                    let JsonWithData:AnyObject! = try! JSONSerialization.jsonObject(with: dados as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    let Mensagens: NSMutableArray = NSMutableArray()
                    if let tudo = JsonWithData! as? NSArray {
                        
                        let contador = tudo.count
                        if contador > 0 {
                            for i in 0...contador-1 {
                                let resultado = tudo[i] as? NSDictionary
                                
                                //let id: Int = Int(resultado!["id"] as! String)!
                                let conteudo: String = resultado!["conteudo"] as? String ?? ""
                                let data: String = resultado!["data"] as? String ?? ""
                                let responsavel_id: String = resultado!["responsavel_id"] as? String ?? ""
                                let tipo: String = resultado!["tipo"] as? String ?? ""
                                let user_id: String = resultado!["user_id"] as? String ?? ""
                                
                                
                                let tudo : NSArray = NSArray(objects: conteudo, data, responsavel_id, tipo, user_id )
                                Mensagens.add(tudo)
                            }
                        }
                        
                    }
                    DispatchQueue.main.async() {
                        self.mensagensObject = Mensagens
                    }
                }
            }
            
        }).resume()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}







