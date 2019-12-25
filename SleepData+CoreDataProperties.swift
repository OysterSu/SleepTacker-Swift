//
//  SleepData+CoreDataProperties.swift
//  SleepTracker-Swift
//
//  Created by 蘇健豪1 on 2019/12/25.
//  Copyright © 2019 蘇健豪. All rights reserved.
//
//

import Foundation
import CoreData


extension SleepData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepData> {
        return NSFetchRequest<SleepData>(entityName: "SleepData")
    }

    @NSManaged public var duration: Float
    @NSManaged public var endTime: Date?
    @NSManaged public var startTime: Date
    @NSManaged public var type: Int16

}
