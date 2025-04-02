import SwiftUI
/*
 ### **Как работает `weak` и `[weak self]` в Swift?**

 В Swift используется **автоматическое управление памятью (ARC — Automatic Reference Counting)**, но если ссылки между объектами создают **циклические зависимости (retain cycles)**, память не освобождается. `weak` и `[weak self]` помогают избежать этих проблем.

 ---

 ## **1. `weak` — слабая ссылка**
 `weak` говорит Swift **не увеличивать счетчик ссылок (retain count)**. Если объект, на который указывает `weak`, уничтожается, ссылка автоматически становится `nil`.

 ### **Пример без `weak` (утечка памяти)**
 ```swift
 class Person {
     var dog: Dog?  // Сильная ссылка
 }

 class Dog {
     var owner: Person?  // Сильная ссылка → ЦИКЛ!
 }

 var person: Person? = Person()
 var dog: Dog? = Dog()

 person?.dog = dog
 dog?.owner = person

 person = nil
 dog = nil  // Объекты не уничтожаются, потому что ссылки друг на друга держат их в памяти
 ```
 - `Person` ссылается на `Dog`, а `Dog` на `Person`.
 - **Обе ссылки сильные (`strong`)**, поэтому объекты **не удаляются**, даже если больше не используются.

 ### **Используем `weak` (решение проблемы)**
 ```swift
 class Person {
     var dog: Dog?
 }

 class Dog {
     weak var owner: Person?  // Теперь Dog не удерживает Person
 }

 var person: Person? = Person()
 var dog: Dog? = Dog()

 person?.dog = dog
 dog?.owner = person

 person = nil  // Теперь Dog не держит ссылку на Person
 dog = nil  // Оба объекта освобождаются
 ```
 - `weak var owner: Person?` означает, что `Dog` **не увеличивает** счетчик ссылок `Person`, поэтому **когда `Person` удаляется, `Dog.owner` автоматически становится `nil`**.

 ---

 ## **2. `[weak self]` в замыканиях (closures)**
 Когда передаешь `self` в замыкание, оно **по умолчанию удерживает `self` сильной ссылкой**, что может привести к утечке памяти.

 ### **Пример утечки памяти**
 ```swift
 class ViewModel {
     var loadData: (() -> Void)?
     
     init() {
         loadData = {
             print("Data loaded")
             self.printData()  // self здесь создает сильную ссылку → утечка памяти
         }
     }

     func printData() {
         print("Printing data")
     }
 }

 var viewModel: ViewModel? = ViewModel()
 viewModel = nil  // Объект не освобождается, потому что замыкание удерживает self
 ```
 - Замыкание **захватывает `self`**, создавая **сильную ссылку**.
 - Даже если `viewModel = nil`, **объект не удалится**.

 ### **Используем `[weak self]` (решение проблемы)**
 ```swift
 class ViewModel {
     var loadData: (() -> Void)?
     
     init() {
         loadData = { [weak self] in  // Теперь self захватывается слабо
             print("Data loaded")
             self?.printData()  // self может быть nil, поэтому self?
         }
     }

     func printData() {
         print("Printing data")
     }
 }

 var viewModel: ViewModel? = ViewModel()
 viewModel = nil  // Теперь объект освобождается
 ```
 - `[weak self]` говорит замыканию: **«Не удерживай `self` сильно»**.
 - Теперь, если объект уничтожен, `self` становится `nil`, **и замыкание не вызовет утечку памяти**.

 ---

 ## **3. Почему `self?` при использовании `[weak self]`**
 Когда используешь `[weak self]`, объект может стать `nil`, поэтому `self` становится **опциональным (`Optional`)**.

 Пример:
 ```swift
 { [weak self] in
     self?.doSomething()  // self может быть nil, поэтому используем self?
 }
 ```
 Если объект уничтожен, `self` будет `nil`, и вызов `doSomething()` **не произойдет**.

 ---

 ## **4. Когда использовать `[unowned self]` вместо `[weak self]`?**
 - **`weak`** → `self` может стать `nil`, и нужно писать `self?`
 - **`unowned`** → `self` **никогда не должен быть `nil`**, иначе будет **краш** приложения.

 ### **Пример `unowned`**
 ```swift
 class ViewModel {
     var loadData: (() -> Void)?
     
     init() {
         loadData = { [unowned self] in  // Говорим: "self не будет nil"
             print("Data loaded")
             self.printData()  // self напрямую, без self?
         }
     }

     func printData() {
         print("Printing data")
     }
 }

 var viewModel: ViewModel? = ViewModel()
 viewModel = nil  // ❌ КРАШ, если вызов loadData() произойдет после удаления объекта
 ```
 - `unowned` означает, что **мы гарантируем, что `self` не будет `nil`**.
 - Если `viewModel` уничтожен, но потом вызывается `loadData()`, **будет краш (EXC_BAD_ACCESS)**.

 **Вывод:**
 - **Используй `[weak self]`, если объект может исчезнуть.**
 - **Используй `[unowned self]`, если объект 100% должен существовать, пока выполняется код.**

 ---

 ### **5. Как это связано с твоим кодом?**
 ```swift
 DispatchQueue.global().asyncAfter(deadline: .now() + 500) { [weak self] in
     self?.data = "New data!"
 }
 ```
 - **Почему `[weak self]`?**
   - Потому что через **500 секунд** объект `wsSecondScreenViewModel` может уже быть удален.
   - Если бы использовался `self.data = "New data!"`, а объект удалили → **приложение бы крэшнулось**.
   - `[weak self]` предотвращает краш, делая `self?` **опциональным**.

 ---

 ## **Вывод**
 | Вариант        | Когда использовать? | Как работает? |
 |---------------|--------------------|--------------|
 | `weak var` | Для слабых ссылок между объектами | Автоматически становится `nil`, когда объект удаляется |
 | `[weak self]` | В замыканиях, если объект может исчезнуть | `self?` нужен для проверки, так как `self` может быть `nil` |
 | `[unowned self]` | Если `self` **точно** не должен быть `nil` | Безопасно только если `self` гарантированно существует |

 В твоем коде `[weak self]` защищает от краша, если объект будет уничтожен до истечения 500 секунд.
 */
struct wsView: View {
    
    @AppStorage("count") var count: Int?
    
    init(){
        count = 0
    }
    
    var body: some View{
        NavigationView{
            NavigationLink("Navigate", destination: wsSecondScreen())
                .navigationTitle(Text("First View"))
        }
        .overlay{
            VStack{
                HStack{
                    Spacer()
                    Text("\(count ?? 0)")
                        .font(.largeTitle)
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
}

struct wsSecondScreen: View {
    @StateObject var vm = wsSecondScreenViewModel()
    
    var body: some View{
        Text("Second View")
        
        if let data = vm.data{
            Text(data)
        }
    }
}

class wsSecondScreenViewModel: ObservableObject{
    @Published var data: String? = nil
    
    init(){
        print("INITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    deinit{
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
        print("DEINITIALIZE NOW")
    }
    
    func getData(){
        //это задание будет делать каждые 500 секунд. Референсов будет много что приведет лагам
        DispatchQueue.global().asyncAfter(deadline: .now() + 500) { [weak self] in
            self?.data = "New data!"
        }
    }
}

#Preview {
    wsView()
}
