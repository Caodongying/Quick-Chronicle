//
//  ContentView.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-01-07.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(entity: DailyRecord.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DailyRecord.date, ascending: false)]) var records: FetchedResults<DailyRecord>


    @State private var textInput: String = ""
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var labelMessage: String = ""
    @State private var showLabel = false
    @State private var showHistory = false
    
    private let currentDate: String = getCurrentDate()
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .center){
                VStack{
                    
                    Text(currentDate)
                    
                    ScrollView{
                        TextEditor(text: $textInput)
                            .frame(height: 200.0)
                            .lineSpacing(3)
                    }.padding()
                    
                    
                    HStack{
//                        NavigationLink(destination: RecordsHistoryView()) {
//                            Text("打开编年史")
//                        }
                        Button("打开编年史"){
                            openHistory()
                        }
                        Spacer()
                        Button("上传"){
                            uploadDiary()
                        }
                        
                    }
                    .padding([.leading, .bottom, .trailing], 40.0)
                }.padding()
                
                if(showLabel) {
                    HStack{
                        Text("🎉")
                        Text(labelMessage)
                    }
                    .padding(10)
                    .background(Color.mint.opacity(0.4))
                    .transition(.opacity)
                    .cornerRadius(8)
                }
                
            }.padding()
            
            
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage)
                    )
                }
        }
        .navigationTitle("快速编年史")
    }
    
    // functions
    
    private func activateAlert(title: String, msg: String) {
        showAlert = true
        alertTitle = title
        alertMessage = msg
    }
    
    private func uploadDiary() {
        // 1. parse the input
        // 2. store the parse result
        let pattern = "【[^【】]*】([^【]*)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        // look up the input
        guard let results = regex?.matches(in: textInput, options: [], range: NSRange(location: 0, length: textInput.count)), !results.isEmpty
        else{
            activateAlert(
                title: "Oops🫣",
                msg: "Don't forget to add keyword wrapper 【】."
            )
            return
        }
        
        var allSaved = true
        
        for result in results
        // result: the range of one keyword-detail pair
        {
            let pair = (textInput as NSString).substring(with: result.range)
            
            // retrieve the keywords and details
            let subpattern = "【.*】"
            let subregex = try? NSRegularExpression(pattern: subpattern, options: [])
            guard let rangeKeywords = subregex?.firstMatch(in: pair, options: [], range: NSRange(location: 0, length: pair.count)), !rangeKeywords.resultType.isEmpty
            else{
                activateAlert(
                    title: "Oops🫣",
                    msg: "Couldn't find keyword!"
                )
                return
            }
            let keyword = (pair as NSString).substring(with: NSRange(location: 1, length: (rangeKeywords.range.length)-2)).trim()
            
            let detail = (pair as NSString).substring(with: NSRange(location: rangeKeywords.range.upperBound, length: pair.count - rangeKeywords.range.upperBound)).trim()
        
            do{
                try DataController.shared.addDailyRecord(keyword: keyword, detail: detail, context: viewContext)
   
            } catch {
                // pop up - failed to save
                activateAlert(
                    title: "Oops🫣",
                    msg: "Failed to save daily records with keyword \(keyword): \(error.localizedDescription)"
                )
                allSaved = false
                break
            }
        }
        
        if allSaved {
            // successfully saved the record
            withAnimation{
                labelMessage = "Record is saved."
                showLabel = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation{
                    showLabel = false
                    labelMessage = ""
                }
            }
        }
        
        clearTextEditor()

    }
    
    func openHistory() {
        showHistory.toggle()
        print("showHistory is: " + String(showHistory))
        let records = fetchDailyRecord(context: viewContext)
        print(records)
        for record in records{
            print("key: \(String(describing: record.keyword))")
            print("date: \(String(describing: record.date))")
            print("detail: \(String(describing: record.detail))")
            print("id: \(String(describing: record.id))")
        }
        
    }
    
    func fetchDailyRecord(context: NSManagedObjectContext) -> [DailyRecord]{
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        
        do{
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            print("Failed to fetch daily records: \(error)")
            return []
        }
    }
    
    private func clearTextEditor(){
        textInput = ""
    }
}


private func getCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let dateString = formatter.string(from: date)
    return dateString
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



#Preview {
    ContentView().environment(\.managedObjectContext, DataController.shared.persistentContainer.viewContext)
}
