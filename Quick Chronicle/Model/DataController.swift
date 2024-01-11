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
    let container = NSPersistentContainer(name: "Quick_Chronicle")
    
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
            let nsError = error as NSError
            fatalError("Failed to save the data: \(nsError), \(nsError.userInfo)")
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
