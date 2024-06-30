//
//  RecordsHistoryView.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-06-30.
//

import SwiftUI

struct RecordsHistoryView: View {
    @State private var showDetailsIsOn = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchByDateText = ""
    @State private var searchByContentText = ""
    
    var body: some View {
        VStack {
            HStack{
                Spacer() // it's so ugly to keep million Spacer(); improve this later
                
                Toggle("Show Details", isOn: $showDetailsIsOn)
                
                Spacer()
                
                Image(systemName: "line.3.horizontal.decrease.circle")
    
                
                DatePicker("From",
                           selection: $startDate,
                           displayedComponents: .date
                ).datePickerStyle(.compact)
                
                DatePicker("To",
                           selection: $endDate,
                           displayedComponents: .date
                ).datePickerStyle(.compact)
                
                Spacer()
                
            }
            
            HStack {
                Image(systemName: "sparkle.magnifyingglass")
                    .foregroundColor(.orange)
                // add a search bar here
                
                Button("Search", action: searchByDate)
            }
            //.searchable(text: $searchByDateText, prompt: "search by date")
            
            HStack {
                Image(systemName: "sparkle.magnifyingglass")
                    .foregroundColor(.orange)
                // add a search bar here
                
                Button("Search", action: searchByContent )
            }
            
            // show the searching result
            // a list
            
        }
    }
    
    func searchByDate(){
        print("Click on butter searchByDate")
    }
    
    func searchByContent(){
        print("Click on butter searchByContent")
    }
}

#Preview {
    RecordsHistoryView()
}
