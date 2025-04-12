import SwiftUI


// Что тут будет использовано
/*
 1.background threads
 2.weak self
 3.Combine
 4.Publishers and Subscribers
 5.FileManager
 6.NSCache
 */


// url = https://jsonplaceholder.typicode.com/photos

/*
  {
     "albumId": 1,
     "id": 1,
     "title": "accusamus beatae ad facilis cum similique qui sunt",
     "url": "https://via.placeholder.com/600/92c952",
     "thumbnailUrl": "https://via.placeholder.com/150/92c952"
  }
 */

struct DownloadingImagesCacheView: View {
    @StateObject var vm: DownloadingImagesViewModel = .init()
    var body: some View {
        NavigationStack{
            List{
                ForEach(vm.dataArray) { model in
                    DownloadingImagesRow(model: model)
                }
            }
            .navigationTitle(Text("Downloading Images"))
        }
    }
}

#Preview {
    DownloadingImagesCacheView()
}
