//
//  SobreViewController.swift
//  Gappe
//
//  Created by Catwork on 07/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class SobreViewController: UIViewController {

    @IBOutlet weak var versao: UILabel!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    let urlCatwork = URL(string: "http://www.catwork.com.br/site_catwork/")
    
    @IBAction func abrirSite(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlCatwork!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urlCatwork!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        self.versao.text = "Versão " + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
