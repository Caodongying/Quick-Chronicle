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
    
    func addDailyRecord(keyword: String, detail: String, context: NSManagedObjectContext) throws{
        let record = DailyRecord(context: context)
        
        record.id = UUID()
        record.keyword = keyword
        record.detail = detail
        record.date = Date()
        
        do{
            try context.save()
        } catch {
            throw error
        }
        
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
