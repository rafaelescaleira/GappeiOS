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

class ComunicadosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableComunicados: UITableView!
    @IBOutlet weak var reloadImage: UIImageView!
    
    let activity_view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    var communicated = ComunicadosDatabase.query()?.order(byDescending: "comunicados_criado_em").fetch() as? [ComunicadosDatabase] ?? []
    var communicatedFind = ComunicadosDatabase.query()?.order(byDescending: "comunicados_criado_em").fetch() as? [ComunicadosDatabase] ?? []
    var communicatedID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadImage.image = .fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .white, size: self.reloadImage.bounds.size)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Título do comunicado"
        definesPresentationContext = true
        self.tableComunicados.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.8859606385, green: 0.8895940185, blue: 0.926838696, alpha: 1)
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)

        activity_view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        activity_view.color = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)
        activity_view.center = CGPoint(x: self.view.center.x, y: view.center.y)
        self.view.addSubview(activity_view)
        activity_view.startAnimating()
        
        self.tableComunicados.reloadData()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        
        self.viewWillAppear(true)
        
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.reloadImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.reloadImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
    }
    
    @IBAction func unwindFromComunicados(unwindSegue: UIStoryboardSegue) {  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let logado: String = (UserDefaults.standard.object(forKey: "logado") as? String ?? "")!
        
        if logado != "yes" {
            
            self.refreshControl.endRefreshing()
            performSegue(withIdentifier: "segueUsuarioNaoLogado", sender: self)
        }
            
        else if logado == "yes" {
            
            NetworkManager.isReachable { _ in
                
                if let userID = UserDefaults.standard.object(forKey: "id_user") as? String {
                    
                    self.activity_view.stopAnimating()
                    self.activity_view.hidesWhenStopped = true
                    
                    SynchronizationModel.instance.requestCommunicated(userID: userID) { (success, title, message) in
                        
                        if success {
                            
                            self.communicated = ComunicadosDatabase.query()?.order(byDescending: "comunicados_criado_em").fetch() as? [ComunicadosDatabase] ?? []
                            self.communicatedFind = ComunicadosDatabase.query()?.order(byDescending: "comunicados_criado_em").fetch() as? [ComunicadosDatabase] ?? []
                            self.refreshControl.endRefreshing()
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
                self.refreshControl.endRefreshing()
                
                if self.communicatedFind.isEmpty {
                    
                    self.present(AlertModel.instance.setAlert(title: "Erro de Conexão", message: "Não é possível carregar os comunidados", titleColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), style: .alert), animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == "" {
            
            self.communicatedFind = self.communicated
        }
            
        else {
            
            self.communicatedFind = self.communicated.filter { ($0.comunicados_titulo?.lowercased().contains(searchController.searchBar.text!.lowercased()))!}
        }
        
        self.tableComunicados.reloadData()
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
        
        return self.communicatedFind.isEmpty == true ? 0 : self.communicatedFind.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.communicatedID = communicatedFind[indexPath.row].comunicados_id
        
        if self.communicatedFind[indexPath.row].comunicados_attach != "" {
            
            performSegue(withIdentifier: "segueComAnexo", sender: self)
        }
            
        else {
            
            performSegue(withIdentifier: "segueSemAnexo", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.communicatedFind.isEmpty { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunicatedTableViewCell", for: indexPath) as? CommunicatedTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setCell(title: communicatedFind[indexPath.row].comunicados_titulo, description: communicatedFind[indexPath.row].comunicados_texto, date: communicatedFind[indexPath.row].comunicados_data)
        cell.attachmentImage.image = communicatedFind[indexPath.row].comunicados_attach == "" ? UIImage() : UIImage(named: "ic_attach_file")!
        
        switch (communicatedFind[indexPath.row].comunicados_tipo_id) {
            
        case "1":
            cell.iconImage.image = .fontAwesomeIcon(name: .fileInvoice, style: .solid, textColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.1)
            break;
        case "2":
            cell.iconImage.image = .fontAwesomeIcon(name: .fileInvoiceDollar, style: .solid, textColor: #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 0.1)
            break;
        case "3":
            cell.iconImage.image = .fontAwesomeIcon(name: .graduationCap, style: .solid, textColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.backgroundColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 0.1)
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
    @IBOutlet weak var calendarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.calendarImage.image = .fontAwesomeIcon(name: .calendarAlt, style: .regular, textColor: .darkGray, size: self.calendarImage.bounds.size)
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


