//
//  ContentView.swift
//  Quick Chronicle
//
//  Created by 曹冬颖 on 2024-01-07.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

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

}

func openHistory() {
    print("openHistory")
}

func uploadDiary(_ textInput: String) {
    // 1. parse the input
    // 2. store the parse result
    let pattern = "【(.*?)】((?!【).|\n)*" // \n should be \s
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    guard let results = regex?.matches(in: textInput, options: [], range: NSRange(location: 0, length: textInput.count))
    else{
            print("Couldn't find any match!")
            return
    }
    for result in results
        {
            print((textInput as NSString).substring(with: result.range))
        }
    
}

private func getCurrentDate() -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let dateString = formatter.string(from: date)
    return dateString
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
