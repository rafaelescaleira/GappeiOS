//
//  EdicaoPerfilViewController.swift
//  Gappe
//
//  Created by Catwork on 15/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class EdicaoPerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagemPerfil: UIImageView!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var senhaAntiga: UITextField!
    @IBOutlet weak var novaSenha: UITextField!
    @IBOutlet weak var repetirSenha: UITextField!
    @IBOutlet weak var botaoSalvar: UIButton!
    @IBOutlet weak var labelValidacao: UILabel!
    @IBOutlet weak var heightView: NSLayoutConstraint!
    
    var perfilObject:NSMutableArray = NSMutableArray()
    let database = DatabaseModel()
    let id_user = UserDefaults.standard.object(forKey: "id_user") as! String
    
    @IBAction func Salvar(_ sender: UIButton) {
        
        UserDefaults.standard.set(id_user, forKey: "id_user")
        UserDefaults.standard.set(email.text!, forKey: "email")
        UserDefaults.standard.set(nomeCompleto.text!, forKey: "nome")
        UserDefaults.standard.set(telefone.text!, forKey: "telefone")
        UserDefaults.standard.synchronize()
        
        if senhaAntiga.text != "" && novaSenha.text != "" && repetirSenha.text != ""{
            if novaSenha.text == repetirSenha.text {
                trocarSenha(senhaAntiga: senhaAntiga.text!, senhaNova: novaSenha.text!)
            } else {
                labelValidacao.text = "Senha repetida não confere."
            }
        }
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.enviaDadosPerfil()
            self.imageUploadRequest()
        }
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: false, completion: nil)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: false, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imgData = UserDefaults.standard.object(forKey: "myImageKey") as? NSData {
            let retrievedImg = UIImage(data: imgData as Data)
            imagemPerfil.image = retrievedImg
        }
        
        telefone.delegate = self
        
        nomeCompleto.delegate = self
        email.delegate = self
        telefone.delegate = self
        senhaAntiga.delegate = self
        novaSenha.delegate = self
        repetirSenha.delegate = self
        
        imagemPerfil.layer.cornerRadius = 15
        
        self.nomeCompleto.text = UserDefaults.standard.object(forKey: "nome") as? String
        self.email.text = UserDefaults.standard.object(forKey: "email") as? String
        self.telefone.text = UserDefaults.standard.object(forKey: "telefone") as? String
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TelaLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            self.heightView.constant = 720
        } else {
            self.heightView.constant = 510
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        telefone.resignFirstResponder()
        senhaAntiga.resignFirstResponder()
        nomeCompleto.resignFirstResponder()
        novaSenha.resignFirstResponder()
        repetirSenha.resignFirstResponder()
        return true
    }
    func hideKeyboard() {
        email.resignFirstResponder()
        telefone.resignFirstResponder()
        senhaAntiga.resignFirstResponder()
        nomeCompleto.resignFirstResponder()
        novaSenha.resignFirstResponder()
        repetirSenha.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK:- If Delete button click
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            textField.text!.removeLast()
            return false
        }
        
        if textField == self.telefone
        {
            if (textField.text?.count)! == 2
            {
                textField.text = "(\(textField.text!)) "  //There we are ading () and space two things
            }
            else if (textField.text?.count)! == 10
            {
                textField.text = "\(textField.text!)-" //there we are ading - in textfield
            }
            else if (textField.text?.count)! > 14
            {
                return false
            }
        }
        return true
    }
    
    func dismissKeyboard() {
        repetirSenha.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagemPerfil.contentMode = .scaleAspectFit
            imagemPerfil.image = pickedImage
            
            let imageData = UIImagePNGRepresentation(pickedImage)
            UserDefaults.standard.set(imageData, forKey: "myImageKey")
            UserDefaults.standard.synchronize()
            
        } else {
            print("Erro ao salvar imagem")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func enviaDadosPerfil() {

        let nome = UserDefaults.standard.object(forKey: "nome") ?? ""
        let email = UserDefaults.standard.object(forKey: "email") ?? ""
        let telefone = UserDefaults.standard.object(forKey: "telefone") ?? ""
        
        let url = URL(string: "\(database.getURLBase())/api/users/\(id_user)")
        
        let request = NSMutableURLRequest(url: url!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        //print("id=\(id_user)&nome=\(nome)&email=\(email)&telefone=\(telefone)")
        let data = "id=\(id_user)&nome=\(nome)&email=\(email)&telefone=\(telefone)".data(using: String.Encoding.utf8)
        
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print("erro no enviaDadosPerfil")
            }
            else {
                self.labelValidacao.text = "Dados salvos com sucesso"
                //print(response)
                //let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()
    }
    
    func trocarSenha(senhaAntiga: String, senhaNova: String) {
        
        let url = URL(string: "\(database.getURLBase())/api/users/\(id_user)")
        
        let request = NSMutableURLRequest(url: url!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        //print("id=\(id_user)&antiga=\(senhaAntiga)&nova=\(senhaNova)")
        let data = "id=\(id_user)&antiga=\(senhaAntiga)&nova=\(senhaNova)".data(using: String.Encoding.utf8)
        
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print("erro ao Trocar senha")
            }
            else {
                self.labelValidacao.text = "Senha trocada com sucesso"
//                print(response)
//                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()

    }
    
    
    func imageUploadRequest() {
        
        let url = URL(string: "\(database.getURLBase())/api/users/\(id_user)")
        
        let request = NSMutableURLRequest(url:url!);
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = UIImagePNGRepresentation(imagemPerfil.image!)
        
        if(imageData==nil)  { return; }
        
        let param = [
            "id" : "\(id_user)"
        ]
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "data[foto]", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
        })
        task.resume()
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.png"
        let mimetype = "image/png"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")

        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
