//
//  DataController.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-01-09.
//
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DailyRecord")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        // save context to storage
        do {
            try context.save()
            print("Data successully saved!")
        } catch {
            print("Failed to save the data")
        }
    }
    
    func addDailyRecord(keyword: String, detail: String, context: NSManagedObjectContext) {
        let record = DailyRecord(context: context)
        record.id = UUID()
        record.keyword = keyword
        record.detail = detail
        record.date = Date()
        
        save(context: context)
    }
    
}