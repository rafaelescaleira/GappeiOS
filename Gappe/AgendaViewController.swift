//
//  AgendaViewController.swift
//  Gappe
//
//  Created by Catwork on 27/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    private weak var calendar: FSCalendar!
    private weak var tableView: UITableView!
    var dataSelecionada = ""
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    let database = DatabaseModel()
    var agendaObject: NSMutableArray = NSMutableArray()
    var datesObject: NSArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CustomTableCell.self, forCellReuseIdentifier: "MyCell")
        self.tableView.reloadData()
    }
    
    override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.view.bounds.width, height: height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.locale = Locale(identifier: "pt_BR")
        self.view.addSubview(calendar)
        self.calendar = calendar
        
        self.datesObject = database.selectDates()
        
        let tableview = UITableView(frame: CGRect(x: 0, y: height+60, width: self.view.bounds.width, height: self.view.bounds.height - (height+60)) )
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableview)
        self.tableView = tableview
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("data selecionada: \(self.dateFormatter.string(from: date))")
        dataSelecionada = self.dateFormatter.string(from: date)
        agendaObject = database.selectAllbyDate(data: dataSelecionada)
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesObject.contains(dateString) {
            return 1
        }
//        if self.datesWithMultipleEvents.contains(dateString) {
//            return 3
//        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesObject.contains(dateString) {
            return UIColor.purple
        }
        return nil
    }
    
    
    //table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaObject.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comunicado = agendaObject.object(at: indexPath.row) as! NSArray
        
        ComunicadoINTERNOcomAnexoViewController.id = Int(comunicado.object(at: 0) as! String)!
        let anexo = comunicado.object(at: 12) as? String ?? ""
        if anexo != "" {
            performSegue(withIdentifier: "segueAgendaComAnexo", sender: self)
        } else {
            performSegue(withIdentifier: "segueAgendaSemAnexo", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let agenda = agendaObject.object(at: indexPath.row) as! NSArray
        
        let mostrarAgenda = Int(agenda.object(at: 7) as! String)!
        if mostrarAgenda == 1 {
            let data = agenda.object(at: 8) as! String
            if(data == dataSelecionada) {
                
                cell.textLabel?.text = "  \(agenda.object(at: 3) as! String)"
                let font = UIFont(name: "Helvetica", size: 13.0)
                cell.textLabel?.font = font
                cell.textLabel?.textColor = .darkGray
            }
        }
        
        return cell
    }

}


class CustomTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






