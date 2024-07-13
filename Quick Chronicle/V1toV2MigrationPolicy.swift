//
//  V1toV2MigtationPolicy.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-07-10.
//

import Foundation
import CoreData

class MigrationFromV1ToV2: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject,
                                             in mapping: NSEntityMapping,
                                             manager: NSMigrationManager) throws {
        if sInstance.entity.name == "DailyRecord" {
            // create the new destination instance
            let destinationEntityName = mapping.destinationEntityName!
            let destinationInstance = NSEntityDescription.insertNewObject(forEntityName: destinationEntityName, into: manager.destinationContext)
            
            // prepare the formatted data
            let dateWithTime = sInstance.primitiveValue(forKey: "date") as! Date
            let dateWithoutTime = dateWithTime.formatted(date: .numeric, time: .omitted)
            
            // set the new String date value in the destination instance
            destinationInstance.setPrimitiveValue(dateWithoutTime, forKey: "date")
            
            // copy other attributes
            let attributes = sInstance.entity.attributesByName
            for (attributeName, _) in attributes {
                print("attribute name is \(attributeName)")
                if (attributeName != "date" && attributeName != "favourite") {
                    let value = sInstance.primitiveValue(forKey: attributeName)
                    print(value ?? "no value")
                    destinationInstance.setValue(value, forKey: attributeName)
                }
            }
            
            do {
                try destinationInstance.managedObjectContext?.save()
            } catch {
                print("Failed to save context after migration: \(error)")
            }
            
            manager.associate(sourceInstance: sInstance, withDestinationInstance: destinationInstance, for: mapping)
            
        }
    }
}
