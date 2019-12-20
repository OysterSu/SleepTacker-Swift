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
    typealias MyType = SleepData

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func insert(entityName: String, attributeInfo: [String: Any], callback: @escaping (Result<(), Error>) -> Void) {
        let insertData = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moc) as! MyType

        for (key, value) in attributeInfo {
            insertData.setValue(value, forKey: key)
        }
        
        callback(Result{ try moc.save() })
    }
}
