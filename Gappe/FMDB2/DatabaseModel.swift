//
//  DatabaseModel.swift
//  Gappe
//
//  Created by Catwork on 07/03/18.
//  Copyright © 2018 Catwork. All rights reserved.
//

import Foundation
import UIKit

public class DatabaseModel: NSObject {
    
    let databaseFileName = "GAPPEdatabase.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String

        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        
    }
    
    func jaCriouBanco() -> Bool {
        if FileManager.default.fileExists(atPath: pathToDatabase){
            return true
        } else {
            return false
        }
    }
    
    func deletaBanco() {
        do {
            try FileManager.default.removeItem(atPath: pathToDatabase)
        } catch {
            
        }
    }
    
    func configuraBancoInicial(dadosComunicados: NSArray, dadosMensagens: NSArray) {
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let createComunicadosTableQuery = "create table comunicados (id integer primary key not null, titulo text, tipo_id text, texto text, situacao text, recebe_resposta text, mostrar_agenda text, data text, criado_em text, comunicados_responsavel_id text, colaborador_id text, attach text )"
                    
                    let createMessageTableQuery = "create table mensagens (conteudo text, data text, responsavel_id text, tipo text, user_id text)"
                    
                    do {
                        try database.executeUpdate(createComunicadosTableQuery, values: nil)
                    } catch {
                        print("Could not create table comunicados.")
                        print(error.localizedDescription)
                    }

                    do {
                        try database.executeUpdate(createMessageTableQuery, values: nil)
                    } catch {
                        print("Could not create table mensagens.")
                        print(error.localizedDescription)
                    }

                    
                    let counter = dadosComunicados.count
                    for i in 0..<counter {
                        let dados = dadosComunicados.object(at: i) as! NSArray
                        
                        do {
                            try database.executeUpdate("insert into comunicados values ( '\(dados.object(at: 0) as! Int)', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")', '\(dados.object(at: 5) as? String ?? "")', '\(dados.object(at: 6) as? String ?? "")', '\(dados.object(at: 7) as? String ?? "")', '\(dados.object(at: 8) as? String ?? "")', '\(dados.object(at: 9) as? String ?? "")', '\(dados.object(at: 10) as? String ?? "")', '\(dados.object(at: 11) as? String ?? "")' )", values: nil )
                        }
                        catch {
                            print("Could not insert into table comunicados.")
                            print(error.localizedDescription)
                        }
                    }
                    
                    let counter2 = dadosMensagens.count
                    for i in 0..<counter2 {
                        let dados = dadosMensagens.object(at: i) as! NSArray
                        
                        do {
                            try database.executeUpdate("insert into mensagens values ( '\(dados.object(at: 0) as? String ?? "")', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")' )", values: nil )
                        }
                        catch {
                            print("Could not insert into table mensagens.")
                            print(error.localizedDescription)
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
    
    
    
    func verificaUltimaMensagem() -> String {
        
        var timestamp:String = String()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "SELECT MAX(data) FROM mensagens LIMIT 1"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        if resultado.next() {
                            timestamp = resultado.string(forColumnIndex: 0) ?? ""
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
        if timestamp != "" {
            return timestamp
        } else {
            return "0"
        }
    }
    
    
    func updateComunicado(dadosComunicados: NSArray) {
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                if database.open() {
                    
                    let counter = dadosComunicados.count
                    
                    for i in 0..<counter {
                        let dados = dadosComunicados.object(at: i) as! NSArray
                        
                        do {
                            try database.executeUpdate("insert into comunicados values ( '\(dados.object(at: 0) as! Int)', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")', '\(dados.object(at: 5) as? String ?? "")', '\(dados.object(at: 6) as? String ?? "")', '\(dados.object(at: 7) as? String ?? "")', '\(dados.object(at: 8) as? String ?? "")', '\(dados.object(at: 9) as? String ?? "")', '\(dados.object(at: 10) as? String ?? "")', '\(dados.object(at: 11) as? String ?? "")' )", values: nil )
                        }
                        catch {
                            print("Could not insert into table comunicados.")
                            print(error.localizedDescription)
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
    
    func insertMensagens(dadosMensagens: NSMutableArray) {
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                if database.open() {
                    
                    let counter = dadosMensagens.count
                    
                    for i in 0..<counter {
                        let dados = dadosMensagens.object(at: i) as! NSArray
                        
                        do {
                            try database.executeUpdate("insert into mensagens values ( '\(dados.object(at: 0) as? String ?? "")', '\(dados.object(at: 1) as? String ?? "")', '\(dados.object(at: 2) as? String ?? "")', '\(dados.object(at: 3) as? String ?? "")', '\(dados.object(at: 4) as? String ?? "")' )", values: nil )
                        }
                        catch {
                            print("Could not insert into table mensagens.")
                            print(error.localizedDescription)
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
                    
                    let selectQuery = "select * from comunicados ORDER BY id DESC"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "")
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
    
    
    func selectDates() -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select data from comunicados WHERE mostrar_agenda = 1"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let data : String = resultado.string(forColumnIndex: 0) ?? ""
                            retorno.add(data)
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
    
    func lastMessage() -> NSMutableArray {
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil {
                if database.open() {
                    let query = "SELECT * FROM mensagens ORDER BY data ASC LIMIT 1 "
                    do {
                        let resultadoQuery = try database.executeQuery(query, values: nil)
                        print("resultadoQuery")
                        print(resultadoQuery)
                        if resultadoQuery.string(forColumnIndex: 0) != nil {
                            let tudo : NSArray = NSArray(objects: resultadoQuery.string(forColumnIndex: 0) ?? "", resultadoQuery.string(forColumnIndex: 1) ?? "", resultadoQuery.string(forColumnIndex: 2) ?? "", resultadoQuery.string(forColumnIndex: 3) ?? "", resultadoQuery.string(forColumnIndex: 4) ?? "", resultadoQuery.string(forColumnIndex: 5) ?? "")
                            retorno.add(tudo)
                        }                        
                    } catch {
                        print("ERRO.")
                        print(error.localizedDescription)
                    }
                    database.close()
                } else {
                    print("Não foi possível conectar com o Banco.")
                }
            }
        }
        return retorno
    }
    
    func selectMensagens() -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from mensagens ORDER BY data ASC"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "")
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
    
    
    
    func selectAllbyDate(data: String) -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from comunicados WHERE data = '\(data)' AND mostrar_agenda = 1"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "")
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
    
    
    
    func selectPesquisa(stringPesquisa: String) -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from comunicados WHERE titulo LIKE '%\(stringPesquisa)%' ORDER BY id DESC"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 0) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "" )
                            retorno.add(tudo)
                        }
                        
                    }
                    catch {
                        print("Could not select on table comunicados.")
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
    
    
    
    
    func selectComunicadoByID(idParam: Int) -> NSMutableArray {
        
        let retorno: NSMutableArray = NSMutableArray()
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                
                if database.open() {
                    
                    let selectQuery = "select * from comunicados WHERE id = \(idParam)"
                    
                    do {
                        let resultado = try database.executeQuery(selectQuery, values: nil)
                        
                        while resultado.next() {
                            
                            let tudo : NSArray = NSArray(objects: resultado.string(forColumnIndex: 2) ?? "", resultado.string(forColumnIndex: 1) ?? "", resultado.string(forColumnIndex: 3) ?? "", resultado.string(forColumnIndex: 4) ?? "", resultado.string(forColumnIndex: 5) ?? "", resultado.string(forColumnIndex: 6) ?? "", resultado.string(forColumnIndex: 7) ?? "", resultado.string(forColumnIndex: 8) ?? "", resultado.string(forColumnIndex: 9) ?? "", resultado.string(forColumnIndex: 10) ?? "", resultado.string(forColumnIndex: 11) ?? "" )
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
    
    
    func getURLBase() -> String {
         return "http://165.227.86.154"
        //return "http://192.168.25.36/gappe"
    }
    
    
    func enviaToken() {
        let token:String = UserDefaults.standard.object(forKey: "token") as! String
        if let id_user = UserDefaults.standard.object(forKey: "id_user") as? String {
            
            let url = URL(string:"\(self.getURLBase())/api/users/\(id_user)")
            
            let request = NSMutableURLRequest(url: url!)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            
            //print("id=\(id_user)&antiga=\(senhaAntiga)&nova=\(senhaNova)")
            let data = "token=\(token)".data(using: String.Encoding.utf8)
            
            request.httpBody = data
            
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil {
                    print("erro ao trocar senha")
                }
                else {
                    //let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                }
            }
            dataTask.resume()
        }
    }
    
    
}









