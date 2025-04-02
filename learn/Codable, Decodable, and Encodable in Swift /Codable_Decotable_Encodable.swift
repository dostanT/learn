import SwiftUI

//Codable = Decodable + Encodable
//(2) тут мы можем добавить Decodable
//(4) теперь тут нас Encodable он нужен для того что бы переделать файл в другой формат
struct CustomerModel: Identifiable, /*Decodabl + Encodable = */ Codable{
    // тут мы не можем дать id рандомное локальное значение. Когда мы принаем значение с сервера мы получаем уже присвоенный ID так что мне остается сделать так как показоно ниже
    
    let id: String
    let name: String
    let point: Int
    let isPremium: Bool
    
    /*
     
     это нужно было когда у нас не было Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case point
        case isPremium
    }
    
    
    init(id: String, name: String, point: Int, isPremium: Bool) {
        self.id = id
        self.name = name
        self.point = point
        self.isPremium = isPremium
    }
    //(3) так, получается тут у декодер и CodingKeys для которого будем создавать enum
    init(from decoder: Decoder)  throws {
        // тут у нас данные
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // тут как в обычном init
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.point = try container.decode(Int.self, forKey: .point)
        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
    }
    
    //(4) вот как раз таки у нас тут функция для енкодинга
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.point, forKey: .point)
        try container.encode(self.isPremium, forKey: .isPremium)
    }
     */
}


class CodableDecEncViewModel: ObservableObject {
    
    @Published var customer: CustomerModel? = CustomerModel(
        id: "1",
        name: "Dostan",
        point: 5,
        isPremium: true)
    
    
    init(){
        getData()
    }
    
    // (1) вот это кнш все курто но можно сделать по проще в моделе
    func getData(){
        guard let data = getJSONData() else {return}
//        print("JSON DATA:")
//        print(data)
//        let jsonData: String? = String(data: data, encoding: .utf8)
//        print(jsonData!)
        
        /*
         
         Это теперь не нужно когда есть (3)
        if
            let localData = try? JSONSerialization.jsonObject(
                with: data,
                options: []),
            let dictionary = localData as? [String: Any],
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let point = dictionary["point"] as? Int,
            let isPremium = dictionary["isPremium"] as? Bool
        {
            let newCustomer = CustomerModel(
                id: id,
                name: name,
                point: point,
                isPremium: isPremium)
            
            customer = newCustomer
         }
         */
        
        
        //что бы использовать (3)
        do{
            self.customer = try JSONDecoder().decode(CustomerModel.self, from: data)
        } catch let error{
            print("ERROR: \(error)")
        }
       
    }
    
    func getJSONData() -> Data?{
        //это для Encoding
        let customer = CustomerModel(id: "1111", name: "Emily", point: 100, isPremium: true)
        let jsonData = try? JSONEncoder().encode(customer)
        
        // это для Decoding
//        let dictionary: [String: Any] = [
//            "id" : "12345",
//            "name" : "Joe",
//            "point" : 10,
//            "isPremium" : true
//        ]
//        
//        let jsonData = try? JSONSerialization.data(
//            withJSONObject: dictionary,
//            options: [])
        return jsonData
    }
}

struct CodableDecEncView: View {
    
    @StateObject var vm: CodableDecEncViewModel = .init()
    
    var body: some View {
        VStack{
            if let customer = vm.customer {
                Text("\(customer.id) \(customer.name) \(customer.point) \(customer.isPremium)")
            }
        }
    }
}

#Preview {
    CodableDecEncView()
}
