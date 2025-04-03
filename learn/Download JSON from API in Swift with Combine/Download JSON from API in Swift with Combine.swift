//
//  Download JSON from API in Swift with Combine.swift
//  learn
//
//  Created by Dostan Turlybek on 03.04.2025.
//


import SwiftUI
import Combine

struct PostModelForCodable: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadJSONFromAPIInSwiftWithCombineViewModel: ObservableObject {
    @Published var posts: [PostModelForCodable] = []
    var cancellebles = Set<AnyCancellable>()
    
    init(){
        getPosts()
    }
    
    func getPosts(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        
        //Combine
        /*
        1. sign up for monthly subscription for package to be delivered
        2. the company would make the package behind the scene
        3. recieve the package at your front door
        4. make sure the box isn't damaged
        5. open and make sure the item is correct
        6. use the item!!!
        7. cancellable at any time!!!
        
        
        1. create publisher
        2. subscribe publisher on background thread
        3. receive on main thread
        4. tryMap(that is data is good)
        5. decode(decode data into PostModelForCodable)
        6. sink(put the item into our app)
        7. store(cancel subscription if needed)
        */
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handlerOutput)
            .decode(type: [PostModelForCodable].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                case .finished:
                    print("COMPLETION: \(completion)")
                case .failure(let error):
                    print("There was an error: \(error)")
                }
                
            } receiveValue: { [weak self] returnedPosts in
                self?.posts = returnedPosts
            }
            .store(in: &cancellebles)
        
        func handlerOutput(_ output: Publishers.SubscribeOn<URLSession.DataTaskPublisher, DispatchQueue>.Output) throws -> Data{
            guard let response = output.response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300
            else {
                throw URLError(.badServerResponse)
            }
            return output.data
        }
        
    }
}

struct DownloadJSONFromAPIInSwiftWithCombineView: View {
    
    @StateObject var vm: DownloadJSONFromAPIInSwiftWithCombineViewModel = .init()
    
    var body: some View {
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

