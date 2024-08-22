//
//  RecordsHistoryView.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-06-30.
//

import SwiftUI

func formatDate(_ date: Date) -> String {
    return date.formatted(date: .numeric, time: .omitted)
}

//extension DailyRecord {
//    @objc
//    var formattedDate: String { date?.formatted(date: .numeric, time: .omitted) ?? "No Date Available" }
//    var formattedDate: String {
//        return formatDate(date!)
//    }
//}

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
    @State private var searchByContentText = ""
    @State private var selectThisWeek = false
    @State private var selectThisMonth = false
    @State private var selectDuration = false
    @State private var onlyShowStars = false
    @State private var filterType: FilterType = .default15
    @State private var predicate: NSPredicate? = nil
    
    
    enum FilterType: String, CaseIterable {
        case thisWeek = "thisweek"
        case thisMonth = "thismonth"
        case dateRange = "daterange"
        case default15 = "default15"
    }
    
    @SectionedFetchRequest<String, DailyRecord> (
        sectionIdentifier: \DailyRecord.date!,
        //sectionIdentifier: \DailyRecord.formattedDate,
        sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
    ) var recordSections
    
    @Environment(\.managedObjectContext) var viewContext
    
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
                            checkEmptyDateFilter()
                            if selectThisWeek {
                                selectThisMonth = false
                                selectDuration = false
                                filterType = .thisWeek
                                
                                predicate = NSPredicate(format: "date >= %@ AND date <= %@", formatDate(Calendar.current.date(byAdding: .day, value: -7, to: Date())!), formatDate(Date()))
                            }
                        }
                        Toggle("This month", isOn: $selectThisMonth).onChange(of: selectThisMonth){
                            checkEmptyDateFilter()
                            if selectThisMonth {
                                selectThisWeek = false
                                selectDuration = false
                                filterType = .thisMonth
                                
                                predicate = NSPredicate(format: "date >= %@ AND date <= %@", formatDate(Calendar.current.date(byAdding: .month, value: -1, to: Date())!), formatDate(Date()))
                            }
                        }
//                        Text(formatDate(startDate))
//                        Text(formatDate(endDate))
                        Toggle("", isOn: $selectDuration).onChange(of: selectDuration){
                            checkEmptyDateFilter()
                            if selectDuration {
                                selectThisMonth = false
                                selectThisWeek = false
                                filterType = .dateRange
                                
                                predicate = NSPredicate(format: "date >= %@ AND date <= %@", formatDate(startDate), formatDate(endDate))
                            }
                        }
                        
                        DatePicker("From",
                                   selection: $startDate,
                                   in: ...Date(), 
                                   displayedComponents: .date
                        ).datePickerStyle(.compact).onChange(of: startDate){
                            if selectDuration {
                                predicate = NSPredicate(format: "date >= %@ AND date <= %@", formatDate(startDate), formatDate(endDate))
                            }
                        }
                        
                        DatePicker("To",
                                   selection: $endDate,
                                   in: ...Date(),
                                   displayedComponents: .date
                        ).datePickerStyle(.compact).onChange(of: endDate){
                            if selectDuration {
                                predicate = NSPredicate(format: "date >= %@ AND date <= %@", formatDate(startDate), formatDate(endDate))
                            }
                        }
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
                    ForEach(recordSections) { section in
                        HStack {
                            Text(section.id)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 3)
                                .background(.lightBlue)
                            HStack{
                                ForEach(section) { record in
                                    if( record.keyword != "" && record.keyword != nil){
                                        Text(record.keyword! + ";")
                                    }
                                }
                            }
                            .padding(.vertical, 3)
                            
                        }
                    }
                    .onChange(of: predicate) { oldPredicate, newPredicate in
                        // Update the predicate for the fetch request
                        recordSections.nsPredicate = newPredicate
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
    
    func checkEmptyDateFilter() {
        let dateFiltered = selectThisWeek || selectThisMonth || selectDuration
        print("dateFiltered is \(dateFiltered)")
        if (!dateFiltered) {
            predicate = nil
        }
    }
    
}

#Preview {
    RecordsHistoryView()
}
