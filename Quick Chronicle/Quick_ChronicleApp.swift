//
//  Quick_ChronicleApp.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-01-07.
//

import SwiftUI

@main
struct Quick_ChronicleApp: App {

    @StateObject private var dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
            RecordsHistoryView().environment(\.managedObjectContext, dataController.persistentContainer.viewContext) // remove this later! Todo: navigation to this view when clicking on 打开编年史
        }
    }
}
