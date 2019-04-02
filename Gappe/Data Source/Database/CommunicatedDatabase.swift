//
//  CommunicatedDatabase.swift
//  Gappe
//
//  Created by Rafael Escaleira on 26/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class ComunicadosDatabase: SRKObject {
    
    @objc dynamic var comunicados_id: Int = 0
    @objc dynamic var comunicados_titulo: String?
    @objc dynamic var comunicados_tipo_id: String?
    @objc dynamic var comunicados_texto: String?
    @objc dynamic var comunicados_situacao: String?
    @objc dynamic var comunicados_recebe_resposta: String?
    @objc dynamic var comunicados_mostrar_agenda: String?
    @objc dynamic var comunicados_data: String?
    @objc dynamic var comunicados_criado_em: Int = 0
    @objc dynamic var comunicados_comunicados_responsavel_id: String?
    @objc dynamic var comunicados_colaborador_id: String?
    @objc dynamic var comunicados_attach: String?
    @objc dynamic var comunicados_resposta: Int = 0
}
