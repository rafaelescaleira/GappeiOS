//
//  MessageDatabase.swift
//  Gappe
//
//  Created by Rafael Escaleira on 28/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class MessageDatabase: SRKObject {
    
    @objc dynamic var message_id: Int = 0
    @objc dynamic var message_user_id: Int = 0
    @objc dynamic var message_responsavel_id: Int = 0
    @objc dynamic var message_conteudo: String?
    @objc dynamic var message_tipo: Bool = false
    @objc dynamic var message_lido: Bool = false
    @objc dynamic var message_data: Int32 = 0
}
