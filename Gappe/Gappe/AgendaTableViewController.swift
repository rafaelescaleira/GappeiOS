//
//  AgendaTableViewController.swift
//  Gappe
//
//  Created by Catwork on 23/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class AgendaTableViewController: UITableViewController {
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    var comunicadosAgenda:NSMutableArray = NSMutableArray()
    let database = DatabaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        comunicadosAgenda = database.selectAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comunicadosAgenda.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell", for: indexPath) as! AgendaTableViewCell
        
        let comunicado = comunicadosAgenda.object(at: indexPath.row) as! NSArray
        
        cell.titulo.text = comunicado.object(at: 1) as? String
        cell.desc.text = comunicado.object(at: 3) as? String
        cell.data.text = comunicado.object(at: 8) as? String
        
        return cell
    }
    

}
