//
//  DBManager.swift
//
//  Created by Mittal Banker on 30/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import FMDB

class DBManager: NSObject {
    
    static let shared: DBManager = DBManager()
    let databaseFileName = "Locationdb.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    var queue: FMDatabaseQueue?
    
    
    
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        let _ = self.createDatabase()
    }
    
    // MARK: - DBManager event functions
    func createDatabase() -> Bool {
        var created = false
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(databaseFileName)

            do {
                try FileManager.default.copyItem(atPath: (documentsURL?.path)!, toPath: pathToDatabase)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        }
        queue = FMDatabaseQueue(path: pathToDatabase)
        print("dbpath" + pathToDatabase)
        return created
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    /*
 public var time : String
 public var lattitude : String
 public var longitude : String
 public var current_time_interval : String
 public var next_time_interval : String*/
    func insertLocationData(location:Location) {
        if openDatabase() {

            var fieldString:String
            var valueString:String
            var createTableQuery:String
            fieldString = "time,lattitude,longitude,current_time_interval,next_time_interval"
            valueString = "'\(location.time )','\(location.longitude )','\(location.lattitude)','\(location.current_time_interval )','\(location.next_time_interval )' )"
            createTableQuery = "Insert into TBL_LOCATION (\(fieldString)) values (\(valueString);"

            if !database.executeStatements(createTableQuery) {

                if(Constants.DEBUG_MODE){
                print("\n\(createTableQuery)\n")
                print("Failed to insert initial data into the database.")
                print(DBManager.shared.database.lastError(), DBManager.shared.database.lastErrorMessage())
                }
            }
        }
    }

}


