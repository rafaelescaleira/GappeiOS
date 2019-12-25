//
//  UserDatabase.swift
//  Gappe
//
//  Created by Rafael Escaleira on 28/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class UserDatabase: SRKObject {
    
    @objc dynamic var user_id: Int = 0
    @objc dynamic var user_nome: String = ""
    @objc dynamic var user_telefone: String = ""
    @objc dynamic var user_email: String = ""
    @objc dynamic var user_foto: Data = Data()
    @objc dynamic var user_device_token: String = ""
    @objc dynamic var user_trocar_senha: Bool = false
    @objc dynamic var user_isLogin: Bool = false
}
