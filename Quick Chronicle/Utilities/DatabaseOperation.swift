//
//  DatabaseFix.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-08-21.
//

import Foundation
import CoreData


class DataBaseFix {
    static func addMissingUUID(context: NSManagedObjectContext) throws{
        let records = DatabaseUtils.fetchDailyRecord(context: context)
        for record in records {
            if (record.id != nil) {
                continue
            }
            print("Here is one record missing UUID")
            record.id = UUID()
        }
        do{
            try context.save()
        } catch {
            throw error
        }
//        for record in records {
//            if record.id == nil {
//                print("Record \(record.keyword) has no UUID")
//            } else {
//                print("Record \(record.keyword) has UUID \(record.id)")
//            }
//        }
    }
}

class DatabaseUtils {
    static func fetchDailyRecord(context: NSManagedObjectContext) -> [DailyRecord]{
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        
        do{
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            print("Failed to fetch daily records: \(error)")
            return []
        }
    }
}



