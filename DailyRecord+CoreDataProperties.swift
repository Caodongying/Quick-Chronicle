//
//  DailyRecord+CoreDataProperties.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-01-07.
//
//

import Foundation
import CoreData


extension DailyRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyRecord> {
        return NSFetchRequest<DailyRecord>(entityName: "DailyRecord")
    }

    @NSManaged public var date: Date?
    @NSManaged public var keyword: String?
    @NSManaged public var detail: String?

}

extension DailyRecord : Identifiable {

}
