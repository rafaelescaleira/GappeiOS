//
//  AnexoWebViewController.swift
//  Gappe
//
//  Created by Catwork on 13/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit

class AnexoWebViewController: UIViewController {

    @IBOutlet weak var AnexoWebView: UIWebView!
    var comunicadoDados:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = DatabaseModel()
        comunicadoDados = database.selectComunicadoByID(idParam: ComunicadoINTERNOcomAnexoViewController.id)
        
        if comunicadoDados.count > 0 {
            let dadoArray = comunicadoDados.object(at: 0) as! NSArray
            
            let urlAnexo = URL(string: (dadoArray.object(at: 10) as? String)!)
            let anexoRequest = URLRequest(url: urlAnexo!)
            AnexoWebView.loadRequest(anexoRequest)
        
        }
        
    }
    
    
    @IBAction func baixarAnexo(_ sender: UIBarButtonItem) {
        
        if comunicadoDados.count > 0 {
            
            let dadoArray = comunicadoDados.object(at: 0) as! NSArray
            
            let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
            
            let fileURL = URL(string: (dadoArray.object(at: 10) as? String)!)

            let ext = fileURL?.pathExtension
            
            let destinationFileUrl = documentsUrl.appendingPathComponent("download.\(ext!)")
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let request = URLRequest(url:fileURL!)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    print("Status code: \(String(describing: statusCode))")
                    if statusCode == 200 {
                        print("Successfully downloaded.")
                    }
                    
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                    
                } else {
                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "erro");
                }
            }
            task.resume()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}





