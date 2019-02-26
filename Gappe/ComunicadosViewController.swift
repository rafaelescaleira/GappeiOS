//
//  ViewController.swift
//  Gappe
//
//  Created by Catwork on 27/02/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class ComunicadosDatabase: SRKObject {
    
    @objc dynamic var comunicados_id: Int = 0
    @objc dynamic var comunicados_titulo: String?
    @objc dynamic var comunicados_tipo_id: String?
    @objc dynamic var comunicados_texto: String?
    @objc dynamic var comunicados_situacao: String?
    @objc dynamic var comunicados_recebe_resposta: String?
    @objc dynamic var comunicados_mostrar_agenda: String?
    @objc dynamic var comunicados_data: String?
    @objc dynamic var comunicados_criado_em: String?
    @objc dynamic var comunicados_comunicados_responsavel_id: String?
    @objc dynamic var comunicados_colaborador_id: String?
    @objc dynamic var comunicados_attach: String?
    @objc dynamic var comunicados_resposta: Int = 0
}

class ComunicadosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var tableComunicados: UITableView!
    let database = DatabaseModel()
    
    var comunicadosObject:NSMutableArray = NSMutableArray()
    var id_user:String = ""
    let activity_view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var idComunicado = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

//        print(UserDefaults.standard.object(forKey: "logado") ?? "")
//        print(UserDefaults.standard.object(forKey: "id_user") ?? "")
//        print(UserDefaults.standard.object(forKey: "device_token") ?? "")
//        print(UserDefaults.standard.object(forKey: "email") ?? "")
//        print(UserDefaults.standard.object(forKey: "foto") ?? "")
//        print(UserDefaults.standard.object(forKey: "nome") ?? "")
//        print(UserDefaults.standard.object(forKey: "telefone") ?? "")

        activity_view.frame =  CGRect(x: 0, y: 0, width: 20, height: 20)
        activity_view.color = UIColor(red:0.7, green:0.7, blue:0.7, alpha:1.0)
        activity_view.center = CGPoint(x: self.view.center.x, y: view.center.y)
        self.view.addSubview(activity_view)
        activity_view.startAnimating()
        self.tableComunicados.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableComunicados.layoutMargins = UIEdgeInsets.zero
        tableComunicados.separatorInset = UIEdgeInsets.zero
        
        
        let logado: String = (UserDefaults.standard.object(forKey: "logado") as? String ?? "")!
        if logado != "yes" { //usuario nao logado
            performSegue(withIdentifier: "segueUsuarioNaoLogado", sender: self)
            
        } else if logado == "yes" {
            getComunicados()

            let when = DispatchTime.now() + 2.6
            DispatchQueue.main.asyncAfter(deadline: when) {
                if self.comunicadosObject.count > 0 {
                    self.database.updateComunicado(dadosComunicados: self.comunicadosObject)
                }
            }
            let when2 = DispatchTime.now() + 2.8
            DispatchQueue.main.asyncAfter(deadline: when2) {
                self.comunicadosObject = self.database.selectAll()
                self.tableComunicados.reloadData()
                self.activity_view.stopAnimating()
                self.activity_view.hidesWhenStopped = true
                self.tableComunicados.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueSemAnexo" {
            
            let vcDestino = segue.destination as! ComunicadoINTERNOViewController
            vcDestino.comunicadoSelecionado = ComunicadosDatabase.query()?.where("comunicados_id = \(idComunicado)")?.fetch()?.firstObject as? ComunicadosDatabase ?? ComunicadosDatabase()
        }
        
        if segue.identifier == "segueComAnexo" {
            
            let vcDestino = segue.destination as! ComunicadoINTERNOcomAnexoViewController
            vcDestino.comunicadoSelecionado = ComunicadosDatabase.query()?.where("comunicados_id = \(idComunicado)")?.fetch()?.firstObject as? ComunicadosDatabase ?? ComunicadosDatabase()
        }
    }
    
    func getComunicados() {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        if let idUser = UserDefaults.standard.object(forKey: "id_user") as? String {
            print(idUser)
            let UrlApiComunicados = "\(database.getURLBase())/api/comunicados/meus_comunicados/\(idUser)/0"
            
            if let url = NSURL(string: UrlApiComunicados) {
                
                session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print("Erro ao conectar com o servidor.")
                    }
                    else{
                        let dados:NSData = NSData(data: data!)
                        do {
                            let JsonWithData:AnyObject! = try! JSONSerialization.jsonObject(with: dados as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
//                            print("Comunicados::::")
//                            print(JsonWithData)
                            let comunicados: NSMutableArray = NSMutableArray()
                            if let todosEventos = JsonWithData! as? NSArray {
                                let contador = todosEventos.count
                                if contador > 0 {
                                    for i in 0...contador-1 {
                                        
                                        autoreleasepool {
                                            
                                            let resultado = todosEventos[i] as? NSDictionary
                                            let novoComunicado = ComunicadosDatabase()
                                            
                                            let id: Int = Int(resultado!["id"] as! String)!
                                            novoComunicado.comunicados_id = id
                                            let titulo: String = resultado!["titulo"] as? String ?? ""
                                            novoComunicado.comunicados_titulo = titulo
                                            let tipo_id: String = resultado!["tipo_id"] as? String ?? ""
                                            novoComunicado.comunicados_tipo_id = tipo_id
                                            let texto: String = resultado!["texto"] as? String ?? ""
                                            novoComunicado.comunicados_texto = texto
                                            let situacao: String = resultado!["situacao"] as? String ?? ""
                                            novoComunicado.comunicados_situacao = situacao
                                            let recebe_resposta: String = resultado!["recebe_resposta"] as? String ?? ""
                                            novoComunicado.comunicados_recebe_resposta = recebe_resposta
                                            let mostrar_agenda: String = resultado!["mostrar_agenda"] as? String ?? ""
                                            novoComunicado.comunicados_mostrar_agenda = mostrar_agenda
                                            let data: String = resultado!["data"] as? String ?? ""
                                            novoComunicado.comunicados_data = data
                                            let criado_em: String = resultado!["criado_em"] as? String ?? ""
                                            novoComunicado.comunicados_criado_em = criado_em
                                            let comunicados_responsavel_id: String = resultado!["comunicados_responsavel_id"] as? String ?? ""
                                            novoComunicado.comunicados_comunicados_responsavel_id = comunicados_responsavel_id
                                            let colaborador_id: String = resultado!["colaborador_id"] as? String ?? ""
                                            novoComunicado.comunicados_colaborador_id = colaborador_id
                                            let attach: String = resultado!["attach"] as? String ?? ""
                                            novoComunicado.comunicados_attach = attach
                                            
                                            novoComunicado.commit()
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
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comunicadosObject.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comunicado = comunicadosObject.object(at: indexPath.row) as! NSArray
        
        ComunicadoINTERNOcomAnexoViewController.id = Int(comunicado.object(at: 0) as! String)!
        idComunicado = Int(comunicado.object(at: 0) as! String)!
        let anexo = comunicado.object(at: 12) as? String ?? ""
        if anexo != "" {
            performSegue(withIdentifier: "segueComAnexo", sender: self)
        } else {
            performSegue(withIdentifier: "segueSemAnexo", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comunicadoCELL", for: indexPath) as! ComunicadoCELL
        let comunicado = comunicadosObject.object(at: indexPath.row) as! NSArray

        cell.titulo.text = comunicado.object(at: 1) as? String
        cell.desc.text = comunicado.object(at: 3) as? String
        cell.data.text = comunicado.object(at: 8) as? String
        
        if (comunicado.object(at: 12) as? String)! != "" {
            let imagem: UIImage = UIImage(named: "ic_attach_file")!
            cell.temAnexo.image = imagem
        } else {
            cell.temAnexo.image = UIImage()
        }

        let tipo: String = (comunicado.object(at: 2) as? String)!
        switch (tipo) {
            case "1":
                cell.imagem_ic?.image = UIImage(named: "ic_administrativo")
                break;
            case "2":
                cell.imagem_ic?.image = UIImage(named: "ic_financeiro")
                break;
            case "3":
                cell.imagem_ic?.image = UIImage(named: "ic_pedagogico")
                break;
            default: break
                
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}




