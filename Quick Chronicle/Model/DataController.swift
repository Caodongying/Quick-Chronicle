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
    // use singleton pattern as suggested in the documentation
    static let shared = DataController()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quick_Chronicle")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        return container
    }()
        
    func save(context: NSManagedObjectContext) {
        // save context to storage
        do {
            try context.save()
            print("Data successfully saved!")
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
    
    func deleteStorage() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DailyRecord.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
}
