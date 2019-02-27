//
//  DatabaseSharkModel.swift
//  Gappe
//
//  Created by Rafael Escaleira on 26/02/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit
import SharkORM

class DatabaseSharkModel {
    
    static let instance = DatabaseSharkModel()
    
    func getLastChangeCommunicated() -> String {
        
        let result = SharkORM.rawQuery("SELECT MAX(change.comunicados_criado_em) AS comunicados_criado_em FROM ComunicadosDatabase change").rawResults.mutableArrayValue(forKey: "comunicados_criado_em").firstObject as? Int ?? Int.min
        return String(result)
    }
}
