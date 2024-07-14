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
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        
        // I googled this
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = false
        description.shouldMigrateStoreAutomatically = true
        
        container.persistentStoreDescriptions.append(description)
        
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        
        if let url = container.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
        
        return container
    }()
    
    func formatDate(date: Date) -> String {
        return date.formatted(date: .numeric, time: .omitted)
    }
    
    func addDailyRecord(keyword: String, detail: String, context: NSManagedObjectContext) throws{
        let record = DailyRecord(context: context)
        
        record.id = UUID()
        record.keyword = keyword
        record.detail = detail
        record.date = formatDate(date: Date())
        //record.date = Date()
        
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
