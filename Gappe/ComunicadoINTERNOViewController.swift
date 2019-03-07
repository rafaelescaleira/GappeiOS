//
//  ComunicadoINTERNOViewController.swift
//  Gappe
//
//  Created by Catwork on 06/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class ComunicadoINTERNOViewController: UIViewController {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UITextView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var answerPresentation: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editHeight: NSLayoutConstraint!
    @IBOutlet weak var answerHeight: NSLayoutConstraint!
    @IBOutlet weak var noHeight: NSLayoutConstraint!
    @IBOutlet weak var yesHeight: NSLayoutConstraint!
    
    var comunicadoSelecionado = ComunicadosDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editButton.setImage(UIImage(named: "PenSquare")!, for: .normal)
        
        self.titulo.text = self.comunicadoSelecionado.comunicados_titulo
        self.texto.text = self.comunicadoSelecionado.comunicados_texto
        
        if comunicadoSelecionado.comunicados_recebe_resposta == "0" {
            
            yesButton.alpha = 0
            noButton.alpha = 0
            answerPresentation.alpha = 0
            editButton.alpha = 0
            
            noHeight.constant = 0
            yesHeight.constant = 0
            answerHeight.constant = 0
            editHeight.constant = 0
        }
            
        else {
            
            if comunicadoSelecionado.comunicados_resposta == 0 {
                
                answerPresentation.text = "RESPOSTA NÃO"
                answerPresentation.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.1215686275, blue: 0.007843137255, alpha: 1)
                yesButton.alpha = 0
                noButton.alpha = 0
                answerPresentation.alpha = 1
                editButton.alpha = 1
            }
                
            else if comunicadoSelecionado.comunicados_resposta == 1 {
                
                answerPresentation.text = "RESPOSTA SIM"
                answerPresentation.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)
                yesButton.alpha = 0
                noButton.alpha = 0
                answerPresentation.alpha = 1
                editButton.alpha = 1
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

/* Actions */

extension ComunicadoINTERNOViewController {
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Back", sender: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.yesButton.alpha = 1
            self.noButton.alpha = 1
            self.answerPresentation.alpha = 0
            self.editButton.alpha = 0
        })
    }
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        
        SynchronizationModel.instance.requestCommunicateAnswer(parameters: SynchronizationModel.instance.getParametersCommunicatedAnswer(resposta: 1, idCommunicated: (self.comunicadoSelecionado.comunicados_comunicados_responsavel_id! as NSString).integerValue)) { (success, title, message) in
            
            if success {
                
                self.comunicadoSelecionado.comunicados_resposta = 1
                self.comunicadoSelecionado.commit()
                
                self.answerPresentation.text = "RESPOSTA SIM"
                self.answerPresentation.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5764705882, alpha: 1)
                
                UIView.animate(withDuration: 0.4, animations: {
                    
                    self.yesButton.alpha = 0
                    self.noButton.alpha = 0
                    self.answerPresentation.alpha = 1
                    self.editButton.alpha = 1
                })
            }
                
            else {
                
                self.present(AlertModel.instance.setAlert(title: title, message: message, titleColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), style: .alert), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        
        SynchronizationModel.instance.requestCommunicateAnswer(parameters: SynchronizationModel.instance.getParametersCommunicatedAnswer(resposta: 0, idCommunicated: (self.comunicadoSelecionado.comunicados_comunicados_responsavel_id! as NSString).integerValue)) { (success, title, message) in
            
            if success {
                
                self.comunicadoSelecionado.comunicados_resposta = 0
                self.comunicadoSelecionado.commit()
                
                self.answerPresentation.text = "RESPOSTA NÃO"
                self.answerPresentation.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.1215686275, blue: 0.007843137255, alpha: 1)
                
                UIView.animate(withDuration: 0.4, animations: {
                    
                    self.yesButton.alpha = 0
                    self.noButton.alpha = 0
                    self.answerPresentation.alpha = 1
                    self.editButton.alpha = 1
                })
            }
                
            else {
                
                self.present(AlertModel.instance.setAlert(title: title, message: message, titleColor: #colorLiteral(red: 0.146513015, green: 0.2318824828, blue: 0.5776452422, alpha: 1), style: .alert), animated: true, completion: nil)
            }
        }
    }
}
