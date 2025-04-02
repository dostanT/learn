//
//  JSONAPI.swift
//  learn
//
//  Created by Dostan Turlybek on 02.04.2025.
//


import SwiftUI

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class JsonAPIViewModel: ObservableObject{
    
    @Published var posts: [PostModel] = []
    
    init(){
        getPost()
    }
    
    func getPost(){
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        //@escaping
        downloadData(fromURL: url) { data in
            if let data = data{
                do {
                    let newPosts = try JSONDecoder().decode([PostModel].self, from: data)
                    //работа происходит асихронно до тех пор пока не выполнится вся функция. Оно встает в очередь уже обработтаная
                    DispatchQueue.main.async { [weak self] in
                        self?.posts = newPosts
                    }
                } catch {
                    print("JSON Decoding Error: \(error)")
                }
            } else{
                print("No Data Returned")
            }
            
        }
        
    }
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()){
        //(1) тут скачиваем дааные с указованного url
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                completionHandler(nil)
                return
            }
            guard error == nil else {
                print("ERROR: \(String(describing:error))")
                completionHandler(nil)
                return
            }
            guard let response = response as? HTTPURLResponse else{
                print("Invalid Response")
                completionHandler(nil)
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Status code error: \(response.statusCode)")
                completionHandler(nil)
                return
            }
            
            print("Success")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString ?? "1")
            
            
            completionHandler(data)
            
        }.resume() // нужен для того что стартануть сам URLSession
        
    }
}

struct JsonAPIView: View{
    
    @StateObject var vm: JsonAPIViewModel = JsonAPIViewModel( )
    
    var body: some View{
        List {
            Text("Posts")
                .font(.headline)
            
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    JsonAPIView()
}
