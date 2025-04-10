//
//  Save and cache images in a SwiftUI app.swift
//  learn
//
//  Created by Dostan Turlybek on 09.04.2025.
//

import SwiftUI

class CacheManager {
    
    static let instance = CacheManager()
    private init() {
        
    }
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Added to cache")
    }
    
    func remove(name: String){
        imageCache.removeObject(forKey: name as NSString)
        print("Removed from cache")
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}

class SaveAndCacheImagesInASwiftUIAppVieModel: ObservableObject{
    
    @Published var startingImage: UIImage? = nil
    @Published var cachedImage: UIImage? = nil
    let imageName: String = "girl"
    let manager = CacheManager.instance
    
    init(){
        getImageFromAssetsFolderSaveAndCache()
    }
    
    func getImageFromAssetsFolderSaveAndCache() {
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache(){
        guard let image = startingImage else { return }
        manager.add(image: image, name: imageName)
    }
    
    func removeFromCache(){
        manager.remove(name: imageName)
    }
    
    func getFromCache(){
        cachedImage = manager.get(name: imageName)
    }
}

struct SaveAndCacheImagesInASwiftUIAppView: View {
    
    @StateObject var vm: SaveAndCacheImagesInASwiftUIAppVieModel = .init()
    
    var body: some View{
        NavigationStack{
            VStack{
                if let image = vm.startingImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 310, height: 310)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                
                HStack{
                    Button{
                        vm.saveToCache()
                    }label:{
                        Text("Save to Cache")
                    }
                    .frame(width: 150, height: 50)
                    .foregroundStyle(.white)
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
                    
                    Button{
                        vm.removeFromCache()
                    }label:{
                        Text("Delete from Cache")
                    }
                    .frame(width: 150, height: 50)
                    .foregroundStyle(.white)
                    .background(Color(.red))
                    .cornerRadius(10)
                    
                    
                }
                
                Button{
                    vm.getFromCache()
                }label:{
                    Text("Get from cache")
                }
                .frame(width: 150, height: 50)
                .foregroundStyle(.white)
                .background(Color(.blue))
                .cornerRadius(10)
                
                if let image = vm.cachedImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 310, height: 310)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                Spacer()
            }
            .navigationTitle("Save and cache")
        }
    }
}


#Preview {
    SaveAndCacheImagesInASwiftUIAppView()
}
