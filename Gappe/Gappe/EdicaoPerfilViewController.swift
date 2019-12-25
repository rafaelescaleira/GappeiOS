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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user = UserDatabase()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        telefone.delegate = self
        nomeCompleto.delegate = self
        email.delegate = self
        telefone.delegate = self
        senhaAntiga.delegate = self
        novaSenha.delegate = self
        repetirSenha.delegate = self
        
        senhaAntiga.attributedPlaceholder = NSAttributedString(string: "Senha Antiga", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)])
        novaSenha.attributedPlaceholder = NSAttributedString(string: "Nova Senha", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)])
        repetirSenha.attributedPlaceholder = NSAttributedString(string: "Repetir Senha", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)])
        
        imagemPerfil.layer.cornerRadius = 15
        
        self.nomeCompleto.text = self.user.user_nome.lowercased().capitalized
        self.email.text = self.user.user_email
        self.telefone.text = self.user.user_telefone
        self.imagemPerfil.image = UIImage(data: self.user.user_foto)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TelaLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func imageUploadRequest(completion: @escaping (Bool, String, String) -> ()) {
        
        let url = URL(string: LINK_UPLOAD_PERFIL + "\(self.user.user_id)")!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = self.user.user_foto
        
        let param = ["id" : "\(self.user.user_id)"]
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "data[foto]", imageDataKey: imageData as NSData, boundary: boundary) as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                
                completion(true, "", "")
            }
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

/* Profile Image */

extension EdicaoPerfilViewController {
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Adicionar Foto de Perfil", message: "Seleciona umas das opções para escolher a foto de perfil", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Câmera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Album de Fotos", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        self.imagemPerfil.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

/* Actions */

extension EdicaoPerfilViewController {
    
    @IBAction func Salvar(_ sender: UIButton) {
        
        self.user.user_nome = nomeCompleto.text ?? ""
        self.user.user_email = email.text ?? ""
        self.user.user_telefone = telefone.text ?? ""
        self.user.user_foto = UIImageJPEGRepresentation(self.imagemPerfil.image!, 0.5) ?? Data()
        
        if senhaAntiga.text != "" && novaSenha.text != "" && repetirSenha.text != "" {
            
            if novaSenha.text == repetirSenha.text {
                
                SynchronizationModel.instance.requestChangePassword(userID: self.user.user_id, senhaAntiga: self.senhaAntiga.text!, senhaNova: self.novaSenha.text!) { (s, t, m) in
                    
                    if !s {
                        
                        DispatchQueue.main.async {
                            
                            self.present(AlertModel.instance.setAlert(title: t, message: m, titleColor: #colorLiteral(red: 0.1278943512, green: 0.2034229057, blue: 0.511282519, alpha: 1), style: .alert), animated: true, completion: nil)
                        }
                    }
                }
            }
            
            else {
                
                labelValidacao.text = "Senha repetida não confere."
            }
        }
        
        self.imageUploadRequest { (s, t, m) in
            
            if s {
                
                DispatchQueue.main.async(execute: {
                    
                    SynchronizationModel.instance.requestUploadProfile(user: self.user) { (success, title, message) in
                        
                        if !success {
                            
                            DispatchQueue.main.async {
                                
                                self.present(AlertModel.instance.setAlert(title: title, message: message, titleColor: #colorLiteral(red: 0.1278943512, green: 0.2034229057, blue: 0.511282519, alpha: 1), style: .alert), animated: true, completion: nil)
                            }
                        }
                        
                        else {
                            
                            DispatchQueue.main.async {
                                
                                self.present(AlertModel.instance.setAlert(title: title, message: message, titleColor: #colorLiteral(red: 0.1278943512, green: 0.2034229057, blue: 0.511282519, alpha: 1), style: .alert), animated: true, completion: nil)
                            }
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        self.showAlert()
    }
}

/* Text Field */

extension EdicaoPerfilViewController {
    
    @objc func keyboardWillChange(notification: Notification) {
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            self.heightView.constant = 764
        }
            
        else {
            
            self.heightView.constant = 510
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let bbiSubmit = UIBarButtonItem.init(title: "Pronto", style: .plain, target: self, action: #selector(doBtnSubmit))
        
        bbiSubmit.tintColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)
        toolbar.items = [bbiSpacer, bbiSubmit]
        textField.inputAccessoryView = toolbar
        
        return true
    }
    
    @objc func doBtnSubmit() {
        
        scrollView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.nomeCompleto {
            
            self.email.becomeFirstResponder()
        }
        
        if textField == self.email {
            
            self.telefone.becomeFirstResponder()
        }
        
        if textField == self.telefone {
            
            self.telefone.resignFirstResponder()
        }
        
        if textField == self.senhaAntiga {
            
            self.novaSenha.becomeFirstResponder()
        }
        
        if textField == self.novaSenha {
            
            self.repetirSenha.becomeFirstResponder()
        }
        
        if textField == self.repetirSenha {
            
            self.repetirSenha.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            
            textField.text!.removeLast()
            return false
        }
        
        if textField == self.telefone {
            
            if (textField.text?.count)! == 2 {
                
                textField.text = "(\(textField.text!)) "
            }
                
            else if (textField.text?.count)! == 10 {
                
                textField.text = "\(textField.text!)-"
            }
                
            else if (textField.text?.count)! > 14 {
                
                return false
            }
        }
        
        return true
    }
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
