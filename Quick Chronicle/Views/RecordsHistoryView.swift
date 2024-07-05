//
//  RecordsHistoryView.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-06-30.
//

import SwiftUI

extension DailyRecord {
    @objc
    var formattedDate: String { date?.formatted(date: .numeric, time: .omitted) ?? "No Date Available" }
}

struct RecordsHistoryView: View {
    @State private var showDetailsIsOn = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchByDateText = ""
    @State private var searchByContentText = ""
    
    @SectionedFetchRequest<String, DailyRecord> (
        sectionIdentifier: \DailyRecord.formattedDate,
        sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
    ) var recordSections
    
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        VStack {
            HStack{
                // it's so ugly to keep million Spacer(); improve this later
                
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
                
            }
            .padding()
            
            HStack {
                Image(systemName: "sparkle.magnifyingglass")
                    .foregroundColor(.orange)
                // add a search bar here
                
                Button("Search", action: searchByDate)
            }
            .padding()
            //.searchable(text: $searchByDateText, prompt: "search by date")
            
            HStack {
                Image(systemName: "sparkle.magnifyingglass")
                    .foregroundColor(.orange)
                // add a search bar here
                
                Button("Search", action: searchByContent )
            }
            .padding()
            
            // show the searching result
            // a list
            
            VStack {
                List {
                    ForEach(recordSections) { recordSection in
                        HStack {
                            Text(recordSection.id)
                            ForEach(recordSection) { record in
                                if( record.keyword != ""){
                                    Text(record.keyword! + ";")
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .padding()
    }
    
    func searchByDate(){
        print("Click on butter searchByDate")
    }
    
    func searchByContent(){
        print("Click on butter searchByContent")
    }
    
    func groupByDate(records: [DailyRecord]){
        
    }
}

#Preview {
    RecordsHistoryView()
}
