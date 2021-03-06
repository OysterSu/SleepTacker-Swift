//
//  SleepDataManager.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪 on 2019/12/20.
//  Copyright © 2019 蘇健豪. All rights reserved.
//

import Foundation
import CoreData

class SleepDataManager {
    var moc: NSManagedObjectContext!
    
    typealias callbackClosure = (Result<(), Error>) -> Void
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func insert(entityName: String, attribute: [String: Any], callback: @escaping (Result<SleepData, Error>) -> Void) {
        let insertData = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moc) as! SleepData

        for (key, value) in attribute {
            insertData.setValue(value, forKey: key)
        }
        
        let result = Result{ try moc.save() }
        switch result {
        case .success( _):
            callback(.success(insertData))
        case .failure(let error):
            callback(.failure(error))
        }
    }
    
    func fetch(entityName: String,
               predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]? = nil,
               limit: Int? = nil,
               callback: @escaping (Result<[SleepData], Error>) -> Void) {
        
        let request = NSFetchRequest<SleepData>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        callback(Result { try self.moc.fetch(request) })
    }
    
    func update(entityName: String, predicate: NSPredicate, attibute: [String: Any], callback: @escaping callbackClosure) {
        self.fetch(entityName: entityName, predicate: predicate) { (fetchResult: Result<[SleepData], Error>) in
            switch fetchResult {
            case .success(let sleepDatas):
                for sleepData in sleepDatas {
                    for (key, value) in attibute {
                        sleepData.setValue(value, forKey: key)
                    }
                }
                
                callback(Result{ try self.moc.save() })
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func delete(entityName: String, predicate: NSPredicate, callback: @escaping callbackClosure) {
        self.fetch(entityName: entityName, predicate: predicate) { (fetchResult: Result<[SleepData], Error>) in
            switch fetchResult {
            case .success(let sleepDatas):
                for sleepData in sleepDatas {
                    self.moc.delete(sleepData)
                }
                
                callback(Result{ try self.moc.save() })
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func delete(object: NSManagedObject, callback: @escaping callbackClosure) {
        self.moc.delete(object)
        callback(Result{ try moc.save() })
    }
}
