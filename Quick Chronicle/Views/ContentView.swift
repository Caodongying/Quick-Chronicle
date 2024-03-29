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
    //let viewContext: NSManagedObjectContext = (( NSApplication.shared.delegate as? AppDelegate)?.NSPersistentContainer.viewContext)!
    @Environment(\.dismiss) var dismiss
    @FetchRequest(entity: DailyRecord.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DailyRecord.date, ascending: false)]) var records: FetchedResults<DailyRecord>


    @State private var textInput: String = ""
    private let currentDate: String = getCurrentDate()
    
    var body: some View {
        VStack{
           
            Text(currentDate)
            
            ScrollView{
                TextEditor(text: $textInput)
                    .frame(height: 200.0)
                    .lineSpacing(3)
            }
            
            HStack{
                Button("打开编年史", action: openHistory)
                
                Spacer()
                Button("上传"){ uploadDiary(textInput)
                }

            }
            .padding([.leading, .bottom, .trailing], 40.0)
        }
        
    }
    
    // functions
    
    private func uploadDiary(_ textInput: String) {
        // 1. parse the input
        // 2. store the parse result
        
        // define the regular expression
        // Todo: remove this later!!
        DataController().deleteStorage()
        let pattern = "【(.*?)】((?!【).|\n)*" // \n should be \s
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        // look up the input
        guard let results = regex?.matches(in: textInput, options: [], range: NSRange(location: 0, length: textInput.count))
        else{
                print("Couldn't find any 【keyword】details match!")
                return
        }
        
        for result in results
        // result: the range of one keyword-detail pair
        {
            let pair = (textInput as NSString).substring(with: result.range)
            
            // retrieve the keywords and details
            let subpattern = "【.*】"
            let subregex = try? NSRegularExpression(pattern: subpattern, options: [])
            guard let rangeKeywords = subregex?.firstMatch(in: pair, options: [], range: NSRange(location: 0, length: pair.count))
            else{
                print("Couldn't find keyword!")
                return
            }
            let keyword = (pair as NSString).substring(with: NSRange(location: 1, length: (rangeKeywords.range.length)-2)).trim()
            
            let detail = (pair as NSString).substring(with: NSRange(location: rangeKeywords.range.upperBound, length: pair.count - rangeKeywords.range.upperBound)).trim()
        
            print("key word: \(keyword)  detail: \(detail)")
            DataController().addDailyRecord(keyword: keyword, detail: detail, context: viewContext)
            dismiss()
        }
        print("成功保存！")
        for item in records {
            print("record - ", item)
        }
    }
    
    func openHistory() {
        print("openHistory")
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

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
