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


// only for real-time preview
struct TestRecordSections: Identifiable {
    let id: String
    let records: [TestRecords]
}

// only for real-time preview
struct TestRecords: Identifiable {
    let id = UUID()
    let date: String
    let keyword: String
    let details: String
    let isFavorite: Bool
}

let recordSections: [TestRecordSections] = [
    TestRecordSections(id: "2023.12.22", records: [
        TestRecords(date: "2023.12.22", keyword: "关键词1", details: "", isFavorite: false),
        TestRecords(date: "2023.12.22", keyword: "快乐的谈话", details: "", isFavorite: false),
    ]),
    TestRecordSections(id: "2024.07.05", records: [
        TestRecords(date: "2024.07.05", keyword: "这是测试数据", details: "", isFavorite: false),
        TestRecords(date: "2024.07.05", keyword: "哈哈大笑", details: "", isFavorite: false),
    ]),
]

struct RecordsHistoryView: View {
    @State private var showDetailsIsOn = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchByDateText = ""
    @State private var searchByContentText = ""
    //@State private var selectAll = false
    @State private var selectThisWeek = false
    @State private var selectThisMonth = false
    @State private var selectDuration = false
    @State private var onlyShowStars = false
    @State private var filterType: FilterType = .default15
    
    var predicate: NSPredicate?
    
    
    enum FilterType: String, CaseIterable {
        //case all = "all"
        case thisWeek = "thisweek"
        case thisMonth = "thismonth"
        case dateRange = "daterange"
        case default15 = "default15"
    }
    
    @SectionedFetchRequest<String, DailyRecord> (
        sectionIdentifier: \DailyRecord.formattedDate,
        sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
    ) var recordSections
    
    @Environment(\.managedObjectContext) var viewContext
    
    var filteredSections: SectionedFetchResults<String, DailyRecord> {
        switch filterType {
        case .thisWeek:
            recordSections.nsPredicate = NSPredicate(format: "date >= %@ AND date <= %@", Calendar.current.date(byAdding: .day, value: -7, to: Date())! as CVarArg, Date() as CVarArg)
            return recordSections
        case .thisMonth:
            recordSections.nsPredicate = NSPredicate(format: "date >= %@ AND date <= %@", Calendar.current.date(byAdding: .month, value: -1, to: Date())! as CVarArg, Date() as CVarArg)
            return recordSections
        case .dateRange:
            recordSections.nsPredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
            return recordSections
        case .default15:
            recordSections.nsPredicate = nil
            return recordSections
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top){
                Spacer()
                
                // searching icon
                VStack{
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundColor(.orange)
                }
                
                // search bar and filter
                VStack{
                    TextField("search by content", text: $searchByContentText)
                    
                    HStack{
                        // only one of the three checkboxes can be selected. This is a stupid solution, but I don't have better ideas so far.
                        Toggle("This week", isOn: $selectThisWeek).onChange(of: selectThisWeek){
                            if selectThisWeek {
                                selectThisMonth = false
                                selectDuration = false
                                filterType = .thisWeek
                            }
                        }
                        Toggle("This month", isOn: $selectThisMonth).onChange(of: selectThisMonth){
                            if selectThisMonth {
                                selectThisWeek = false
                                selectDuration = false
                                filterType = .thisMonth
                            }
                        }
                        Toggle("", isOn: $selectDuration).onChange(of: selectDuration){
                            if selectDuration {
                                selectThisMonth = false
                                selectThisWeek = false
                                filterType = .dateRange
                            }
                        }
                        
                        DatePicker("From",
                                   selection: $startDate,
                                   displayedComponents: .date
                        ).datePickerStyle(.compact)
                        
                        DatePicker("To",
                                   selection: $endDate,
                                   displayedComponents: .date
                        ).datePickerStyle(.compact)
                    }.toggleStyle(.checkbox)
                    
                   
                }
                
                // show details and stars
                VStack{
                    Toggle("Show Details", isOn: $showDetailsIsOn)
                    Toggle("Only show stars", isOn: $onlyShowStars)
                }
                
            }
            
            // show the searching result
            // a list
            
            VStack {
                List {
                    ForEach(filteredSections) { section in
                        HStack {
                            Text(section.id)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 3)
                                .background(.lightBlue)
                            HStack{
                                ForEach(section) { record in
                                    if( record.keyword != ""){
                                        Text(record.keyword! + ";")
                                    }
                                }
                            }
                            .padding(.vertical, 3)
                            
                        }
                    }
                    .background(.blueGray)
                    .listRowSeparator(.hidden)
                    //.searchable(text: $resultRange)
                }
            }
            
        }
        .padding()
        .navigationTitle("编年史记录")
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
