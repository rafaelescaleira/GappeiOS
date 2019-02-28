//
//  ScheduleViewController.swift
//  Gappe
//
//  Created by Rafael Escaleira on 27/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class ScheduleViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var communicatedID = 0
    var agendaComunicados = [ComunicadosDatabase]()
    var datasComunicados = [String]()
    var dataSelecionada = ""
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        self.datasComunicados = SharkORM.rawQuery("SELECT comunicados_data FROM ComunicadosDatabase WHERE comunicados_mostrar_agenda = '1'")?.rawResults.mutableArrayValue(forKey: "comunicados_data") as? [String] ?? []
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .clear
        calendar.locale = Locale(identifier: "Pt_BR")
        calendar.appearance.headerTitleFont = UIFont(name: "Avenir-Black", size: 22)!
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

/* Functions */

extension ScheduleViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "comAnexo" {
            
            let vcDestino = segue.destination as! ComunicadoINTERNOcomAnexoViewController
            vcDestino.comunicadoSelecionado = ComunicadosDatabase.query()?.where("comunicados_id = \(communicatedID)")?.fetch()?.firstObject as? ComunicadosDatabase ?? ComunicadosDatabase()
        }
        
        if segue.identifier == "semAnexo" {
            
            let vcDestino = segue.destination as! ComunicadoINTERNOViewController
            vcDestino.comunicadoSelecionado = ComunicadosDatabase.query()?.where("comunicados_id = \(communicatedID)")?.fetch()?.firstObject as? ComunicadosDatabase ?? ComunicadosDatabase()
        }
    }
}

/* Calendar */

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        dataSelecionada = self.dateFormatter.string(from: date)
        
        if self.datasComunicados.contains(dataSelecionada) {
            
            self.agendaComunicados = ComunicadosDatabase.query().where("comunicados_data = '\(dataSelecionada)'").fetch() as? [ComunicadosDatabase] ?? []
        }
        
        else {
            
            self.agendaComunicados = []
        }
        
        
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = self.dateFormatter.string(from: date)
        
        if self.datasComunicados.contains(dateString) {
            
            return 1
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        
        let dateString = self.dateFormatter.string(from: date)
        
        if self.datasComunicados.contains(dateString) {
            
            return UIColor.purple
        }
        
        return nil
    }
}

/* Table View */

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.agendaComunicados.isEmpty == true ? 0 : self.agendaComunicados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaComunicadoTableViewCell", for: indexPath) as? AgendaComunicadoTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setCell(title: self.agendaComunicados[indexPath.row].comunicados_titulo, description: self.agendaComunicados[indexPath.row].comunicados_texto, date: self.agendaComunicados[indexPath.row].comunicados_data)
        cell.attachmentImage.image = self.agendaComunicados[indexPath.row].comunicados_attach == "" ? UIImage() : UIImage(named: "ic_attach_file")!
        
        switch (self.agendaComunicados[indexPath.row].comunicados_tipo_id) {
            
        case "1":
            cell.iconImage.image = .fontAwesomeIcon(name: .fileInvoice, style: .solid, textColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.layer.shadowColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.calendar.appearance.selectionColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            break;
        case "2":
            cell.iconImage.image = .fontAwesomeIcon(name: .fileInvoiceDollar, style: .solid, textColor: #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.layer.shadowColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            self.calendar.appearance.selectionColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            break;
        case "3":
            cell.iconImage.image = .fontAwesomeIcon(name: .graduationCap, style: .solid, textColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), size: cell.iconImage.bounds.size)
            cell.viewPresent.layer.shadowColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1)
            self.calendar.appearance.selectionColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1)
            break;
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.communicatedID = self.agendaComunicados[indexPath.row].comunicados_id
        let anexo = self.agendaComunicados[indexPath.row].comunicados_attach
        
        if anexo != "" {
            
            performSegue(withIdentifier: "comAnexo", sender: self)
        }
        
        else {
            
            performSegue(withIdentifier: "semAnexo", sender: self)
        }
    }
}

class AgendaComunicadoTableViewCell: UITableViewCell {
    
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
