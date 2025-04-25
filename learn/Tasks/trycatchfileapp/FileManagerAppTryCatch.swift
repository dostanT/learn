//
//  FileManagerAppTryCatch.swift
//  learn
//
//  Created by Dostan Turlybek on 25.04.2025.
//

import SwiftUI
import Foundation
// /Users/dostanturlybek/Work/SwiftLerning2025/learn/learn/Tasks/trycatchfileapp/data.txt
class FileManagerForTryCatch {
    let fileManager = FileManager.default
    let filePath = "/Users/dostanturlybek/Work/SwiftLerning2025/learn/learn/Tasks/trycatchfileapp"
    static let shared = FileManagerForTryCatch()
    
    func createFile(named fileName: String, title: String) throws {
        if let data = title.data(using: .utf8) {
            fileManager.createFile(atPath: "\(filePath)/\(fileName).txt", contents: data, attributes: nil)
            print("Файл создан по пути: \(filePath)")
        } else {
            print("Не удалось преобразовать строку в данные.")
        }
    }
    
    func openFile(named fileName: String) throws -> String?{
        var content: String? = nil
        let fullPath: String = filePath + "/\(fileName).txt"
        do {
            content = try String(contentsOfFile: fullPath, encoding: .utf8)
        } catch {
            print("Ошибка при чтении файла: \(error.localizedDescription)")
        }
        return content
    }
}

class FileManagerForTryCatchViewModel: ObservableObject {
    @Published var fileName: String = ""
    @Published var title: String? = ""
    let manager = FileManagerForTryCatch.shared
    
    func createFile() {
        do{
            try manager.createFile(named: fileName, title: title ?? "")
        } catch let error{
            print("ERROR: \(error.localizedDescription)")
        }
        
    }
    
    func openFile() {
        do {
            title = try manager.openFile(named: fileName)
        } catch let error{
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
}

struct FileManagerAppTryCatch: View {
    
    @StateObject private var vm = FileManagerForTryCatchViewModel()
    @State var title: String = ""
    
    var body: some View {
        VStack{
            Text("\(vm.title ?? "")")
            HStack{
                TextField("File name here...", text: $vm.fileName)
                TextField("Title here...", text: $title)
            }
            
            Button("Create file") {
                vm.title = self.title
                vm.createFile()
            }
            
            Button("Open file") {
                vm.openFile()
            }
        }
    }
}

struct FileManagerAppTryCatch_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerAppTryCatch()
    }
}
