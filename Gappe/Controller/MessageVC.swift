//
//  MessageVCViewController.swift
//  Gappe
//
//  Created by Lucas Avila on 05/06/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var reloadImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var topNavigationView: NSLayoutConstraint!
    
    let database = DatabaseModel()
    
    var messagesObject:NSMutableArray = NSMutableArray()
    var id_user:String = ""
    let activity_view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendButton.setImage(UIImage(named: "SendIcon")!, for: .normal)
        self.reloadImage.image = UIImage(named: "Sync")
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        tableMessages.dataSource = self
        
        
        self.messageField.delegate = self
        messagesObject = database.selectMensagens()
        activity_view.frame =  CGRect(x: 0, y: 0, width: 20, height: 20)
        activity_view.color = UIColor(red:0.7, green:0.7, blue:0.7, alpha:1.0)
        activity_view.center = CGPoint(x: self.view.center.x, y: view.center.y)
        self.view.addSubview(activity_view)
        
        if messagesObject.count > 0 {
            scrollToBottom()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableMessages.rowHeight = UITableViewAutomaticDimension
        tableMessages.estimatedRowHeight = 68
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
    }

    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    func hideKeyboard() {
        messageField.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesObject.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesObject.object(at: indexPath.row) as! NSArray
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        cell.message.text = message.object(at: 0) as? String
        cell.label.text = "Gappe"

        if message.object(at: 4) as? String == "" {
            
            cell.label.text = (UserDefaults.standard.object(forKey: "nome") as? String)?.lowercased().capitalized
            cell.message.textAlignment = NSTextAlignment.right
            cell.label.textAlignment = NSTextAlignment.right
            
            cell.label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.message.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
            cell.viewMessage.backgroundColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 0.2)
        }
        
        else {
            
            cell.message.textAlignment = NSTextAlignment.left
            cell.label.textAlignment = NSTextAlignment.left
            
            cell.label.textColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1)
            cell.message.textColor = #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1)
            
            cell.viewMessage.backgroundColor = #colorLiteral(red: 0.9987735152, green: 0.7140055299, blue: 0, alpha: 0.2)
        }
        
        return cell
    }
    
    @IBAction func refresh() {
        
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.reloadImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.reloadImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
        self.messagesObject = database.selectMensagens()
        
        DispatchQueue.main.async(execute: {
            self.tableMessages.reloadData()
            self.scrollToBottom()
        })
    }
    
    @IBAction func send(sender: AnyObject) {
        let timeInterval = Int64(NSDate().timeIntervalSince1970 - (14419))
//        let timeInterval = Int64(NSDate().timeIntervalSince1970)
   
        if let id_user = UserDefaults.standard.object(forKey: "id_user") as? String {
            let text = self.messageField.text!
            let mensagem: NSArray = ["\(text)", "\(timeInterval)"   , id_user, "0", ""]
            print("send method")
            print(mensagem)
            self.messagesObject.add(mensagem)
            DispatchQueue.main.async(execute: {
                self.tableMessages.reloadData()
            })
            database.insertMensagens(dadosMensagens: self.messagesObject)

        }
//        19:51:40
//        1529610700
        self.enviaMensagem(self.messageField.text!)
        messageField.text = nil
        messageField.resignFirstResponder()
        scrollToBottom()
    }
    
    func enviaMensagem(_ mensagem:String ) {
        let url = URL(string: "\(database.getURLBase())/api/escola_mensagens/send")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        
        request.allHTTPHeaderFields = [
            "Accept" : "text/plain",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        if let id_user = UserDefaults.standard.object(forKey: "id_user") as? String {
            
            request.httpMethod = "POST"
            let paramToSend = "responsavel_id=" + id_user + "&conteudo=" + mensagem
            
            request.httpBody = paramToSend.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
            })
            task.resume()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageField.resignFirstResponder()

        return true
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.messagesObject.count > 0 {
                let indexPath = IndexPath(row: self.messagesObject.count-1, section: 0)
                self.tableMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow {
            self.view.frame.origin.y = -keyboardRect.height
            self.topNavigationView.constant = keyboardRect.height
        }
        
        else if notification.name == Notification.Name.UIKeyboardWillHide {
            self.view.frame.origin.y = 0
            self.topNavigationView.constant = 0
        }
    }
}
