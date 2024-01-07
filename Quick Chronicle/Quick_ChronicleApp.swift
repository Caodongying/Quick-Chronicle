//
//  Quick_ChronicleApp.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-01-07.
//

import SwiftUI

@main
struct Quick_ChronicleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
