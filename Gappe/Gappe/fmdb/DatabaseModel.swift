//
//  DatabaseModel.swift
//  Gappe
//
//  Created by Catwork on 07/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//


import Foundation
import UIKit

class DatabaseModel: NSObject {
    
    
    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        print(documentsDirectory)
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        
    }
    
    func jaCriouBanco() -> Bool {
        if FileManager.default.fileExists(atPath: pathToDatabase){
            return true
        } else {
            return false
        }
    }
    
    
    func configuraBancoInicial(dadosCapins: NSArray, dadosMidias: NSArray) {
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let createCapinsTableQuery = "create table capins_main (id integer primary key not null, nome_cientifico text, nome_comum text, origem text, exigencia_fertilidade text, resistencia_seca text, resistencia_frio text, resistencia_acidez text, resistencia_umidade text, resistencia_cigarrinha text, resistencia_fogo text, ciclo_vegetativo text, propagacao text, crescimento text, altura text, precipitacao text, semeadura text, fenacao text, ensilagem text, pb text, producao text, digestibilidade text, palatabilidade text, observacao text, created text, modified text, disponibilidade_germisul text, favorito text )"
                    
                    do {
                        try database.executeUpdate(createCapinsTableQuery, values: nil)
                    } catch {
                        print("Could not create table capins_main.")
                        print(error.localizedDescription)
                    }
                    
                    
                    
                    let createMidiaTableQuery = "create table capins_midia (id integer primary key not null, created text, modified text, titulo text, basename text, descricao text, link text, tipo text, codigo text, destaque text, ordem text, extensao text, mime text, path text )"
                    
                    do {
                        try database.executeUpdate(createMidiaTableQuery, values: nil)
                    } catch {
                        print("Could not create table capins_midia.")
                        print(error.localizedDescription)
                    }
                    
                    let counter = dadosCapins.count
                    for i in 0..<counter {
                        let dados = dadosCapins.object(at: i) as! NSArray
                        
                        do {
                            try database.executeUpdate("insert into capins_main values ( '\(dados.object(at: 0) as! Int)', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")', '\(dados.object(at: 5) as? String ?? "")', '\(dados.object(at: 6) as? String ?? "")', '\(dados.object(at: 7) as? String ?? "")', '\(dados.object(at: 8) as? String ?? "")', '\(dados.object(at: 9) as? String ?? "")', '\(dados.object(at: 10) as? String ?? "")', '\(dados.object(at: 11) as? String ?? "")', '\(dados.object(at: 12) as? String ?? "")', '\(dados.object(at: 13) as? String ?? "")', '\(dados.object(at: 14) as? String ?? "")', '\(dados.object(at: 15) as? String ?? "")', '\(dados.object(at: 16) as? String ?? "")', '\(dados.object(at: 17) as? String ?? "")', '\(dados.object(at: 18) as? String ?? "")', '\(dados.object(at: 19) as? String ?? "")', '\(dados.object(at: 20) as? String ?? "")', '\(dados.object(at: 21) as? String ?? "")', '\(dados.object(at: 22) as? String ?? "")', '\(dados.object(at: 23) as? String ?? "")', '\(dados.object(at: 24) as? String ?? "")', '\(dados.object(at: 25) as? String ?? "")', '\(dados.object(at: 26) as? String ?? "")', 'FALSE' )", values: nil )
                            
                        }
                        catch {
                            //print("Could not insert into table capins_main.")
                            //print(error.localizedDescription)
                        }
                        
                    }
                    
                    let counter2 = dadosMidias.count
                    for i in 0..<counter2 {
                        let dados = dadosMidias.object(at: i) as! NSArray
                        
                        do {
                            try database.executeUpdate("insert into capins_midia values ( '\(dados.object(at: 0) as! Int)', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")', '\(dados.object(at: 5) as? String ?? "")', '\(dados.object(at: 6) as? String ?? "")', '\(dados.object(at: 7) as? String ?? "")', '\(dados.object(at: 8) as? String ?? "")', '\(dados.object(at: 9) as? String ?? "")', '\(dados.object(at: 10) as? String ?? "")', '\(dados.object(at: 11) as? String ?? "")', '\(dados.object(at: 12) as? String ?? "")', '\(dados.object(at: 13) as? String ?? "")' )", values: nil )
                            
                        }
                        catch {
                            //print("Could not insert into table capins_midia.")
                            //print(error.localizedDescription)
                        }
                        
                        
                    }
                    
                    database.close()
                    
                    
                }
                else {
                    print("Could not open the database.")
                }
                
            }
        }
    }
    
    
    func verificaUltimoModified() -> Int {
        
        var timestamp:Int = Int()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "SELECT MAX(strftime('%s', modified)) FROM capins_main"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            timestamp = Int(resultado.string(forColumnIndex: 0) ?? "")!
                        }
                        
                    }
                    catch {
                        print("Could not select on table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return timestamp
    }
    
    
    func update(dadosCapins: NSArray, dadosMidias: NSArray) {
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                
                if database.open() {
                    
                    let counter = dadosCapins.count
                    
                    //Capins
                    for i in 0..<counter {
                        let dados = dadosCapins.object(at: i) as! NSArray
                        
                        
                        //verifica se o registro existe no banco, se existir faz um update, se nao existir faz o insert.
                        var verificaSeExisteID: Int = Int()
                        let selectCount = "select count(*) from capins_main where id = '\(dados.object(at: 0) as! Int)'"
                        do {
                            let resultado = try database.executeQuery(selectCount, values: nil)
                            while resultado.next() {
                                verificaSeExisteID = Int(resultado.string(forColumnIndex: 0) ?? "")!
                            }
                        }
                        catch {
                            print("Could not select on table.")
                            print(error.localizedDescription)
                        }
                        //fim da verificação
                        
                        
                        
                        if verificaSeExisteID == 1 {  // update
                            do {
                                try database.executeUpdate("update capins_main set nome_cientifico = '\(dados.object(at: 1) as? String ?? "")', nome_comum = '\(dados.object(at: 2) as? String ?? "")', origem = '\(dados.object(at: 3) as? String ?? "")', exigencia_fertilidade = '\(dados.object(at: 4) as? String ?? "")', resistencia_seca = '\(dados.object(at: 5) as? String ?? "")', resistencia_frio = '\(dados.object(at: 6) as? String ?? "")', resistencia_acidez = '\(dados.object(at: 7) as? String ?? "")', resistencia_umidade = '\(dados.object(at: 8) as? String ?? "")', resistencia_cigarrinha = '\(dados.object(at: 9) as? String ?? "")', resistencia_fogo = '\(dados.object(at: 10) as? String ?? "")', ciclo_vegetativo = '\(dados.object(at: 11) as? String ?? "")', propagacao = '\(dados.object(at: 12) as? String ?? "")', crescimento = '\(dados.object(at: 13) as? String ?? "")', altura = '\(dados.object(at: 14) as? String ?? "")', precipitacao = '\(dados.object(at: 15) as? String ?? "")', semeadura = '\(dados.object(at: 16) as? String ?? "")', fenacao = '\(dados.object(at: 17) as? String ?? "")', ensilagem = '\(dados.object(at: 18) as? String ?? "")', pb = '\(dados.object(at: 19) as? String ?? "")', producao = '\(dados.object(at: 20) as? String ?? "")', digestibilidade = '\(dados.object(at: 21) as? String ?? "")', palatabilidade = '\(dados.object(at: 22) as? String ?? "")', observacao = '\(dados.object(at: 23) as? String ?? "")', created = '\(dados.object(at: 24) as? String ?? "")', modified = '\(dados.object(at: 25) as? String ?? "")', disponibilidade_germisul = '\(dados.object(at: 26) as? String ?? "")' WHERE id = '\(dados.object(at: 0) as! Int)'", values: nil )
                                
                            }
                            catch {
                                print("Could not update table capins_main.")
                                print(error.localizedDescription)
                            }
                            
                            
                        }else { // insert
                            
                            do {
                                try database.executeUpdate("insert into capins_main values ( '\(dados.object(at: 0) as! Int)', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")', '\(dados.object(at: 5) as? String ?? "")', '\(dados.object(at: 6) as? String ?? "")', '\(dados.object(at: 7) as? String ?? "")', '\(dados.object(at: 8) as? String ?? "")', '\(dados.object(at: 9) as? String ?? "")', '\(dados.object(at: 10) as? String ?? "")', '\(dados.object(at: 11) as? String ?? "")', '\(dados.object(at: 12) as? String ?? "")', '\(dados.object(at: 13) as? String ?? "")', '\(dados.object(at: 14) as? String ?? "")', '\(dados.object(at: 15) as? String ?? "")', '\(dados.object(at: 16) as? String ?? "")', '\(dados.object(at: 17) as? String ?? "")', '\(dados.object(at: 18) as? String ?? "")', '\(dados.object(at: 19) as? String ?? "")', '\(dados.object(at: 20) as? String ?? "")', '\(dados.object(at: 21) as? String ?? "")', '\(dados.object(at: 22) as? String ?? "")', '\(dados.object(at: 23) as? String ?? "")', '\(dados.object(at: 24) as? String ?? "")', '\(dados.object(at: 25) as? String ?? "")', '\(dados.object(at: 26) as? String ?? "")', 'FALSE' )", values: nil )
                                
                            }
                            catch {
                                print("Could not insert into table capins_main.")
                                print(error.localizedDescription)
                            }
                        }
                        
                    }
                    
                    //midias
                    let counter2 = dadosMidias.count
                    for i in 0..<counter2 {
                        let dados = dadosMidias.object(at: i) as! NSArray
                        
                        
                        //verifica se a midia existe no banco, se existir faz um update, se nao existir faz o insert.
                        var verificaSeExisteID: Int = Int()
                        let selectCount = "select count(*) from capins_main where id = '\(dados.object(at: 0) as! Int)'"
                        do {
                            let resultado = try database.executeQuery(selectCount, values: nil)
                            while resultado.next() {
                                verificaSeExisteID = Int(resultado.string(forColumnIndex: 0) ?? "")!
                            }
                        }
                        catch {
                            print("Could not select on table.")
                            print(error.localizedDescription)
                        }
                        //fim da verificação
                        
                        
                        if verificaSeExisteID == 1 {  // update
                            do {
                                try database.executeUpdate("update capins_midia set created = '\(dados.object(at: 1) as? String ?? "")', modified = '\(dados.object(at: 2) as? String ?? "")', titulo = '\(dados.object(at: 3) as? String ?? "")', basename = '\(dados.object(at: 4) as? String ?? "")', descricao = '\(dados.object(at: 5) as? String ?? "")',  link = '\(dados.object(at: 6) as? String ?? "")', tipo = '\(dados.object(at: 7) as? String ?? "")', codigo = '\(dados.object(at: 8) as? String ?? "")', destaque = '\(dados.object(at: 9) as? String ?? "")', ordem = '\(dados.object(at: 10) as? String ?? "")', extensao = '\(dados.object(at: 11) as? String ?? "")', mime = '\(dados.object(at: 12) as? String ?? "")', path = '\(dados.object(at: 13) as? String ?? "")' WHERE id = '\(dados.object(at: 0) as! Int)' ", values: nil )
                                
                            }
                            catch {
                                print("Could not update table capins_midia.")
                                print(error.localizedDescription)
                            }
                            
                        } else { // insert
                            
                            do {
                                try database.executeUpdate("insert into capins_midia values ( '\(dados.object(at: 0) as! Int)', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")', '\(dados.object(at: 5) as? String ?? "")', '\(dados.object(at: 6) as? String ?? "")', '\(dados.object(at: 7) as? String ?? "")', '\(dados.object(at: 8) as? String ?? "")', '\(dados.object(at: 9) as? String ?? "")', '\(dados.object(at: 10) as? String ?? "")', '\(dados.object(at: 11) as? String ?? "")', '\(dados.object(at: 12) as? String ?? "")', '\(dados.object(at: 13) as? String ?? "")' )", values: nil )
                                
                            }
                            catch {
                                print("Could not insert into table capins_midia.")
                                print(error.localizedDescription)
                            }
                        }
                        
                    }
                    
                    
                    
                    database.close()
                    
                    
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
    }
    
    
    func selectAll() -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from capins_main ORDER BY nome_comum ASC"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "", resultado.string(forColumnIndex: 12) ?? "", resultado.string(forColumnIndex: 13) ?? "", resultado.string(forColumnIndex: 14) ?? "", resultado.string(forColumnIndex: 15) ?? "", resultado.string(forColumnIndex: 16) ?? "", resultado.string(forColumnIndex: 17) ?? "", resultado.string(forColumnIndex: 18) ?? "", resultado.string(forColumnIndex: 19) ?? "", resultado.string(forColumnIndex: 20) ?? "", resultado.string(forColumnIndex: 21) ?? "", resultado.string(forColumnIndex: 22) ?? "", resultado.string(forColumnIndex: 23) ?? "", resultado.string(forColumnIndex: 24) ?? "", resultado.string(forColumnIndex: 25) ?? "", resultado.string(forColumnIndex: 26) ?? "", resultado.string(forColumnIndex: 27) ?? "")
                            retorno.add(tudo)
                        }
                        
                    }
                    catch {
                        print("Could not select on table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return retorno
    }
    
    
    func selectAllMidiasByCod(codigo: Int) -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from capins_midia WHERE codigo = \(codigo)"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "", resultado.string(forColumnIndex: 12) ?? "", resultado.string(forColumnIndex: 13) ?? "" )
                            
                            retorno.add(tudo)
                        }
                        
                    }
                    catch {
                        print("Could not select on table Capins.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return retorno
    }
    
    
    
    
    
    func selectPesquisa(nomeComum: String, nomeCient: String) -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from capins_main WHERE nome_comum LIKE '%\(nomeComum)%' OR nome_cientifico LIKE '%\(nomeCient)%' ORDER BY nome_comum"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "", resultado.string(forColumnIndex: 12) ?? "", resultado.string(forColumnIndex: 13) ?? "", resultado.string(forColumnIndex: 14) ?? "", resultado.string(forColumnIndex: 15) ?? "", resultado.string(forColumnIndex: 16) ?? "", resultado.string(forColumnIndex: 17) ?? "", resultado.string(forColumnIndex: 18) ?? "", resultado.string(forColumnIndex: 19) ?? "", resultado.string(forColumnIndex: 20) ?? "", resultado.string(forColumnIndex: 21) ?? "", resultado.string(forColumnIndex: 22) ?? "", resultado.string(forColumnIndex: 23) ?? "", resultado.string(forColumnIndex: 24) ?? "", resultado.string(forColumnIndex: 25) ?? "", resultado.string(forColumnIndex: 26) ?? "", resultado.string(forColumnIndex: 27) ?? "")
                            retorno.add(tudo)
                        }
                        
                    }
                    catch {
                        print("Could not select on table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return retorno
    }
    
    
    
    
    func selectCapimByID(idParam: Int) -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from capins_main WHERE id = \(idParam)"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "", resultado.string(forColumnIndex: 12) ?? "", resultado.string(forColumnIndex: 13) ?? "", resultado.string(forColumnIndex: 14) ?? "", resultado.string(forColumnIndex: 15) ?? "", resultado.string(forColumnIndex: 16) ?? "", resultado.string(forColumnIndex: 17) ?? "", resultado.string(forColumnIndex: 18) ?? "", resultado.string(forColumnIndex: 19) ?? "", resultado.string(forColumnIndex: 20) ?? "", resultado.string(forColumnIndex: 21) ?? "", resultado.string(forColumnIndex: 22) ?? "", resultado.string(forColumnIndex: 23) ?? "" )
                            retorno.add(tudo)
                        }
                        
                    }
                    catch {
                        print("Could not select on table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return retorno
    }
    
    
    
    func selectFavoritos() -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from capins_main WHERE favorito = 'TRUE' "
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "")
                            retorno.add(tudo)
                        }
                        
                    }
                    catch {
                        print("Could not select on table.")
                        print(error.localizedDescription)
                    }
                    
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return retorno
    }

    
    
}







