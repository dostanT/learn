import SwiftUI
import Combine

class PublishersandSubscribersinCombinewithaSwiftUIprojectViewModel: ObservableObject {
    @Published var count: Int = 0
    // этот AnyCancellable только для одного subscriber-а.
    var timer: AnyCancellable?
    
    // этот для многих
    var cancellables = Set<AnyCancellable>()
    
    // Timer это легкий пример как обьяснит работу Publisher and Subcribers
    // теперь задачи по сложнее
    @Published var textFieldText: String = ""
    @Published var isTextValid: Bool = false
    
    @Published var showButton: Bool = false
    
    init(){
        setUpTimer()
        addTextFieldSubscribers()
        addButtonSubscribers()
    }
    
    func setUpTimer(){
        // for one
//        timer = Timer
//            .publish(every: 1.0, on: .main, in: .common)
//            .autoconnect()
//            .sink { complotion in
//                print("complition: \(complotion)")
//            } receiveValue: { [weak self] _ in
//                guard let self = self else { return }
//                
//                self.count += 1
//                
//                if self.count >= 10 {
//                    self.timer?.cancel()
//                }
//            }
        
        //for many
        Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { complotion in
                print("complition: \(complotion)")
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.count += 1
                
//                if self.count >= 10 {
//                    for item in self.cancellables{
//                        item.cancel()
//                    }
//                }
            }
            .store(in: &cancellables)
    }
    
    func addTextFieldSubscribers(){
        $textFieldText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)//ждет 0.5 секунд что бы продолжить потому если челик быстро печатает то код рабоает каждый раз.
            .map { text -> Bool in
                if text.count > 3 {
                    return true
                }
                return false
            }
//            .assign(to: \.isTextValid, on: self)
            .sink(receiveValue: { [weak self] (isValid) in
                self?.isTextValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func addButtonSubscribers(){
        $isTextValid
            .combineLatest($count)
            .sink { [weak self] (isValid, count) in
                guard let self = self else {return}
                
                if isValid && count >= 15 {
                    self.showButton = true
                }
                else{
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
}

struct PublishersandSubscribersinCombinewithaSwiftUIprojectView: View {
    
    @StateObject var vm = PublishersandSubscribersinCombinewithaSwiftUIprojectViewModel()
    
    var body: some View {
        VStack{
            Text("\(vm.count)/15")
                .font(.largeTitle)
            
            TextField("type something...", text: $vm.textFieldText)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding(.horizontal)
                .background(.gray)
                .cornerRadius(10)
                .overlay {
                    HStack{
                        Spacer()
                        Image(systemName: vm.isTextValid ? "checkmark" :"xmark")
                            .padding()
                    }
                }
            Button{
                
            }label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .opacity(vm.showButton ? 1.0 : 0.5)
            }
            .disabled(!vm.showButton)
        }
        .padding()
    }
}

#Preview {
    PublishersandSubscribersinCombinewithaSwiftUIprojectView()
}
