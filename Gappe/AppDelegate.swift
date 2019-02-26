//
//  AppDelegate.swift
//  Gappe
//
//  Created by Catwork on 27/02/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import SharkORM

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, SRKDelegate {

    var window: UIWindow?
    var segue: UIViewController!
    let database = DatabaseModel()
    var mensagensObject:NSMutableArray = NSMutableArray()
    var idUsuario: String = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SharkORM.setDelegate(self)
        SharkORM.openDatabaseNamed("MyDatabase")

        UINavigationBar.appearance().barTintColor = UIColor(red:0.00000, green:0.28235, blue:0.70588, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 3) as Date)
        
        return true
    }
    
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage) {
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: "token")
        UserDefaults.standard.synchronize()
        let database = DatabaseModel()
        database.enviaToken()
    }
    
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("hei ow")
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("lets go")
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let idUser = UserDefaults.standard.object(forKey: "id_user") as? String {
            
            getNovosDados(id_user: idUser)
            
            let when = DispatchTime.now() + 2.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                if self.mensagensObject.count > 0 {
                    self.database.insertMensagens(dadosMensagens: self.mensagensObject)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadList"), object: nil)
                    
                }
            }
            
        }
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.notification.request.content.userInfo["action"] as! String
        
        if action == "chat" {
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navigationMensagens") as? UINavigationController {
                if let window = self.window, let rootViewController = window.rootViewController {
                    var currentController = rootViewController
                    while let presentedController = currentController.presentedViewController {
                        currentController = presentedController
                    }
                    let when = DispatchTime.now() + 2.5
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        let myCustomViewController: MessageVC = MessageVC(nibName: nil, bundle: nil)
                      

                        currentController.present(controller, animated: true, completion: nil)
                        if myCustomViewController.revealViewController() != nil {
                            myCustomViewController.menuBtn.target = myCustomViewController.revealViewController()
                            myCustomViewController.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
                            myCustomViewController.view.addGestureRecognizer(myCustomViewController.revealViewController().panGestureRecognizer())
                        }
                    }
                 
                }
            }
        } else {
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Comunicados") as? UINavigationController {
                if let window = self.window, let rootViewController = window.rootViewController {
                    var currentController = rootViewController
                    while let presentedController = currentController.presentedViewController {
                        currentController = presentedController
                    }
                    currentController.present(controller, animated: true, completion: nil)
                }
            }
            
        }
        completionHandler()
    }
    
    
    
    func getNovosDados(id_user: String) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let dateTime = database.verificaUltimaMensagem()
        
        let UrlApiMensagens = NSURL(string:"\(database.getURLBase())/api/escola_mensagens/sync/\(id_user)/\(dateTime)")

        let request = NSMutableURLRequest(url: UrlApiMensagens! as URL)

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Erro ao conectar com o servidor.")
            } else {
                let dados:NSData = NSData(data: data!)
                do {
                    let JsonWithData:AnyObject! = try! JSONSerialization.jsonObject(with: dados as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    let Mensagens: NSMutableArray = NSMutableArray()
                    if let tudo = JsonWithData! as? NSArray {
 
                        let contador = tudo.count
                        if contador > 0 {
                            for i in 0...contador-1 {
                                let resultado = tudo[i] as? NSDictionary
                                
                                //let id: Int = Int(resultado!["id"] as! String)!
                                let conteudo: String = resultado!["conteudo"] as? String ?? ""
                                let data: String = resultado!["data"] as? String ?? ""
                                let responsavel_id: String = resultado!["responsavel_id"] as? String ?? ""
                                let tipo: String = resultado!["tipo"] as? String ?? ""
                                let user_id: String = resultado!["user_id"] as? String ?? ""
                                
                                let tudo : NSArray = NSArray(objects: conteudo, data, responsavel_id, tipo, user_id )
                                
                                Mensagens.add(tudo)
                            }
                        }
                    }
                    DispatchQueue.main.async() {
                        self.mensagensObject = Mensagens
                    }
                }
            }
        }).resume()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

