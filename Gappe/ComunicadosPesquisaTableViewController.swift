//
//  ComunicadosPesquisaTableViewController.swift
//  Gappe
//
//  Created by Catwork on 18/04/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class ComunicadosPesquisaTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var campoPesquisa: UISearchBar!
    let database = DatabaseModel()
    
    var comunicadosObject:NSMutableArray = NSMutableArray()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        comunicadosObject = database.selectPesquisa(stringPesquisa: campoPesquisa.text!)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.campoPesquisa.delegate = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.title = "Pesquisa"
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero

        self.comunicadosObject = self.database.selectAll()
        self.tableView.reloadData()
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TelaLoginViewController.dismissKeyboard))
        //view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        campoPesquisa.resignFirstResponder()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comunicadosObject.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comunicado = comunicadosObject.object(at: indexPath.row) as! NSArray
        
        ComunicadoINTERNOcomAnexoViewController.id = Int(comunicado.object(at: 0) as! String)!
        let anexo = comunicado.object(at: 12) as? String ?? ""
        if anexo != "" {
            performSegue(withIdentifier: "seguePesquisaComAnexo", sender: self)
        } else {
            performSegue(withIdentifier: "seguePesquisaSemAnexo", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comunicadoPesquisaCELL", for: indexPath) as! ComunicadoPesquisaCell
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
    
}






