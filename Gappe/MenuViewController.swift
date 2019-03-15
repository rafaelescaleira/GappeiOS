//
//  MenuViewController.swift
//  Gappe
//
//  Created by Catwork on 27/02/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var imagemPerfil: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewProfile: CustomNavigationView!
    @IBOutlet weak var heightBackImage: NSLayoutConstraint!
    
    let database = DatabaseModel()
    
    var user = UserDatabase.query().fetch().firstObject as? UserDatabase ?? UserDatabase()
    let menuTitles = ["Comunicados", "Agenda Gappe", "Mensagens", "Meu Perfil", "Escola Gappe", "Sobre", "Sair"]
    let menuTitleImages: [UIImage] = [UIImage(named: "Menu0")!,
    UIImage(named: "Menu1")!,
    UIImage(named: "Menu2")!,
    UIImage(named: "Menu3")!,
    UIImage(named: "Menu4")!,
    UIImage(named: "Menu5")!,
    UIImage(named: "Menu6")!]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController()?.rearViewRevealWidth = 291.66
        self.revealViewController()?.rearViewRevealOverdraw = 0
        
        imagemPerfil.layer.cornerRadius = 15
        imagemPerfil.clipsToBounds = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.global(qos: .background).async {
            
            self.user = UserDatabase.query().fetch().firstObject as? UserDatabase ?? UserDatabase()
            
            DispatchQueue.main.async {
                
                self.nome.text = self.user.user_nome.lowercased().capitalized
                self.email.text = self.user.user_email
                self.imagemPerfil.image = UIImage(data: self.user.user_foto) ?? UIImage()
                self.heightBackImage.constant = self.viewProfile.bounds.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
            
            UserDefaults.standard.removeObject(forKey: "logado")
            UserDefaults.standard.removeObject(forKey: "id_user")
            UserDefaults.standard.removeObject(forKey: "device_token")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "foto")
            UserDefaults.standard.removeObject(forKey: "nome")
            UserDefaults.standard.removeObject(forKey: "telefone")
            UserDefaults.standard.synchronize()
            
            SharkORM.rawQuery("DELETE FROM UserDatabase")
            SharkORM.rawQuery("DELETE FROM ComunicadosDatabase")
            database.deletaBanco()
        }
        
        self.performSegue(withIdentifier: self.menuTitles[indexPath.row], sender: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell else { return UITableViewCell() }
        cell.setCell(title: self.menuTitles[indexPath.row], image: self.menuTitleImages[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        
        print("Download Started")
        
        getData(from: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            DispatchQueue.main.async() {
                
                self.imagemPerfil.image = UIImage(data: data)
            }
        }
    }

}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(title: String?, image: UIImage) {
        
        self.title.text = title
        self.iconImage.image = image
    }
}
