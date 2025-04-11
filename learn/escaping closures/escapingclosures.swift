import SwiftUI
// эта кложура нужна для того что бы функции работали коректно когда загружают данные с инета
class esccloViewModel: ObservableObject {
    @Published var text: String = "Hello"
    @Published var state: Bool = true
    
    
    func getData(){
//        let newData = downloadData()
//        text = newData
        
        downloadData7 { [weak self] returnedResult in
            self?.text = returnedResult.data
        }
        
        downloadData7 { data in
            self.text = data.data
        }
        
        
    }
    
    func downloadData() -> String{
        return "New Data"
    }
    
    func downloadData2() -> String{
        // выдает ошибку потому что "-> String" работает сразу без асинхрона. А в внутри функции мы просим асинхронный return что приводит к ошибке "Cannot convert return expression of type '()' to return type 'String'" и "Cannot convert value of type 'String' to closure result type 'Void'"
        // что бы это испрваить
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            return "NewData"
        })
         */
        return ""
    }
    
    // тут решение проблемы.
    func downloadData3(completionHandler: (_ data: String) -> ()) {
        completionHandler("New Data")
    }
    
    //Escaping closure captures non-escaping parameter 'completionHandler' но и тут есть проблема
//    func downloadData4(completionHandler: (_ data: String) -> ()) {
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            completionHandler("New Data")
//        })
//        
//    }
    
    // нужно добавить параметер @escaping
    func downloadData5(completionHandler: @escaping (_ data: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            completionHandler("New Data")
        })
        
    }
    
    func downloadData6(completionHandler: @escaping (DownloadResult) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            let result = DownloadResult(data: "NewData")
            completionHandler(result)
        })
        
    }
    
    //конечный код
    func downloadData7(completionHandler: @escaping  DownloadCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            let result = DownloadResult(data: "NewData")
            completionHandler(result)
        })
        
    }
    
    deinit {
           print("🧹 esccloViewModel удалён из памяти")
    }
        
}

// такой метод даст flexebility для данных.
struct DownloadResult {
    let data: String
}

// используем typealias для флексебилити
typealias DownloadCompletion = (DownloadResult) -> ()


struct esccloView: View{
    
    @StateObject var vm: esccloViewModel = .init()
    
    var body: some View{
        Text(vm.text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.blue)
            .onTapGesture {
                vm.getData()
            }
    }
}


#Preview {
    esccloView()
}
