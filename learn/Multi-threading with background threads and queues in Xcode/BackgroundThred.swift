import SwiftUI
/*
 background thread нужно для того что загружать видео, фотки с инета или другие тяжелые процессы
 но после этого нужно обязательно перевести из в main thread что бы отобразить в View. Иначе выведет фиолетовую ошибку и гпт говорит что это
            "SwiftUI ожидает, что все обновления ObservableObject происходят на главном потоке (Main Thread), так как UI-поток должен быть безопасным. Если данные изменяются из фонового потока, это может привести к гонке данных (race condition), некорректному отображению UI или даже крашу приложения."
 
 
 */

class btvm: ObservableObject {
    @Published var dataArray: [String] = []
    
    
    func fetchData(){
        // QualityOfService qos
        DispatchQueue.global(qos: .background).async{
            //should give us False and !Thread1
            print("CHECK1: \(Thread.isMainThread)")
            print("CHECK1: \(Thread.current)")
            
            let newData: [String] = self.downloadData()
            DispatchQueue.main.async{
                //should give us True and Thread1
                print("CHECK2: \(Thread.isMainThread)")
                print("CHECK2: \(Thread.current)")
                self.dataArray = newData
            }
        }
        
    }
    
    private func downloadData() -> [String]{
        var data: [String] = []
        
        for x in 0..<100{
            data.append("\(x)")
            print(data)
        }
        return data
    }
}


struct btv: View {
    
    @StateObject var vm = btvm()
    
    var body: some View {
        ScrollView{
            LazyVStack(spacing: 10) {
                Text("LOAD DATA")
                    .font(.largeTitle)
                    .bold()
                    .onTapGesture {
                        vm.fetchData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    btv()
}
