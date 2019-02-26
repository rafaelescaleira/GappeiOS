//
//  MessageVCViewController.swift
//  Gappe
//
//  Created by Lucas Avila on 05/06/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    let database = DatabaseModel()
    
    var messagesObject:NSMutableArray = NSMutableArray()
    var id_user:String = ""
    let activity_view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableMessages.dataSource = self
        
        
        self.messageField.delegate = self
        messagesObject = database.selectMensagens()
        activity_view.frame =  CGRect(x: 0, y: 0, width: 20, height: 20)
        activity_view.color = UIColor(red:0.7, green:0.7, blue:0.7, alpha:1.0)
        activity_view.center = CGPoint(x: self.view.center.x, y: view.center.y)
        self.view.addSubview(activity_view)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name: NSNotification.Name(rawValue: "loadList"), object: nil)
        
        if messagesObject.count > 0 {
            scrollToBottom()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        tableMessages.rowHeight = UITableViewAutomaticDimension
        tableMessages.estimatedRowHeight = 68

    }

    //func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
       // if let messageText = messagesObject[indexPath.item].item{
       
       // }
   // }
    
    func hideKeyboard() {
        messageField.resignFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver("loadList")
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
        cell.label.text = "GAPPE"

        if message.object(at: 4) as? String == "" {
            cell.label.text = UserDefaults.standard.object(forKey: "nome") as? String
            cell.message.textAlignment = NSTextAlignment.right
            cell.label.textAlignment = NSTextAlignment.right
            cell.viewMessage.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9647058824, blue: 1, alpha: 1)
        } else {
            cell.message.textAlignment = NSTextAlignment.left
            cell.label.textAlignment = NSTextAlignment.left
            cell.viewMessage.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        }
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refresh() {
        self.messagesObject = database.selectMensagens()
        
        DispatchQueue.main.async(execute: {
            self.tableMessages.reloadData()
        })
        scrollToBottom()
    }
    
    @IBAction func loadList(){
        self.messagesObject = database.selectMensagens()
        print("MESSAGE VC")
        print(database.lastMessage())
        DispatchQueue.main.async(execute: {
            self.tableMessages.reloadData()
        })
            scrollToBottom()
    
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageField.resignFirstResponder()

        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
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
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }
}
