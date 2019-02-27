//
//  ViewController.swift
//  Gappe
//
//  Created by Catwork on 27/02/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit
import SharkORM
import FontAwesome_swift

class ComunicadosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableComunicados: UITableView!
    
    var communicated = ComunicadosDatabase.query()?.order(byDescending: "comunicados_criado_em").fetch() as? [ComunicadosDatabase] ?? []
    let activity_view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var communicatedID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)

        activity_view.frame =  CGRect(x: 0, y: 0, width: 20, height: 20)
        activity_view.color = UIColor(red:0.7, green:0.7, blue:0.7, alpha:1.0)
        activity_view.center = CGPoint(x: self.view.center.x, y: view.center.y)
        self.view.addSubview(activity_view)
        activity_view.startAnimating()
        
        self.tableComunicados.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let logado: String = (UserDefaults.standard.object(forKey: "logado") as? String ?? "")!
        
        if logado != "yes" {
            
            performSegue(withIdentifier: "segueUsuarioNaoLogado", sender: self)
        }
            
        else if logado == "yes" {
            
            NetworkManager.isReachable { _ in
                
                if let userID = UserDefaults.standard.object(forKey: "id_user") as? String {
                    
                    self.activity_view.stopAnimating()
                    self.activity_view.hidesWhenStopped = true
                    
                    SynchronizationModel.instance.requestCommunicated(idUser: userID) { (success, title, message) in
                        
                        if success {
                            
                            self.communicated = ComunicadosDatabase.query()?.order(byDescending: "comunicados_criado_em").fetch() as? [ComunicadosDatabase] ?? []
                            self.tableComunicados.reloadData()
                            self.activity_view.stopAnimating()
                            self.activity_view.hidesWhenStopped = true
                        }
                    }
                }
            }
            
            NetworkManager.isUnreachable { _ in
                
                self.activity_view.stopAnimating()
                self.activity_view.hidesWhenStopped = true
                
                if self.communicated.isEmpty {
                    
                    self.present(AlertModel.instance.setAlert(title: "Erro de Conexão", message: "Não é possível carregar os comunidados", titleColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), style: .alert), animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueSemAnexo" {
            
            let vcDestino = segue.destination as! ComunicadoINTERNOViewController
            vcDestino.comunicadoSelecionado = ComunicadosDatabase.query()?.where("comunicados_id = \(communicatedID)")?.fetch()?.firstObject as? ComunicadosDatabase ?? ComunicadosDatabase()
        }
        
        if segue.identifier == "segueComAnexo" {
            
            let vcDestino = segue.destination as! ComunicadoINTERNOcomAnexoViewController
            vcDestino.comunicadoSelecionado = ComunicadosDatabase.query()?.where("comunicados_id = \(communicatedID)")?.fetch()?.firstObject as? ComunicadosDatabase ?? ComunicadosDatabase()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.communicated.isEmpty == true ? 0 : self.communicated.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.communicatedID = communicated[indexPath.row].comunicados_id
        
        if self.communicated[indexPath.row].comunicados_attach != "" {
            
            performSegue(withIdentifier: "segueComAnexo", sender: self)
        }
            
        else {
            
            performSegue(withIdentifier: "segueSemAnexo", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.communicated.isEmpty { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunicatedTableViewCell", for: indexPath) as? CommunicatedTableViewCell else { return UITableViewCell() }
        
        cell.setCell(title: communicated[indexPath.row].comunicados_titulo, description: communicated[indexPath.row].comunicados_texto, date: communicated[indexPath.row].comunicados_data)
        cell.attachmentImage.image = communicated[indexPath.row].comunicados_attach == "" ? UIImage() : UIImage(named: "ic_attach_file")!
        
        switch (communicated[indexPath.row].comunicados_tipo_id) {
            
        case "1":
            cell.iconImage.image = .fontAwesomeIcon(name: .fileInvoice, style: .solid, textColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.layer.shadowColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            break;
        case "2":
            cell.iconImage.image = .fontAwesomeIcon(name: .fileInvoiceDollar, style: .solid, textColor: #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.layer.shadowColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            break;
        case "3":
            cell.iconImage.image = .fontAwesomeIcon(name: .graduationCap, style: .solid, textColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.layer.shadowColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1)
            break;
        default:
            break
        }
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class CommunicatedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var attachmentImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var viewPresent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewPresent.layer.shadowRadius = 4.5
        self.viewPresent.layer.shadowOpacity = 0.5
        self.viewPresent.layer.shadowOffset = .zero
        self.viewPresent.layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(title: String?, description: String?, date: String?) {
        
        self.title.text = title
        self.descriptionLabel.text = description
        self.date.text = date
    }
}


