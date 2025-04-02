import SwiftUI


/*
 
 Допустим мы создали нетфликс и там соответсвенно добавили очень много фильмов. У нас очень много моделей MovieModel и хотелось бы доавить еще TVShowsModel.
 
 */
struct MoviewModel{
    let title: String
    let director: String
    let count: Int
}
// TVShow ссылается на модел MoviewModel
typealias TVShowModel = MoviewModel

struct tView: View {
    
    //@State var item = MoviewModel(title: "Title", director: "joe", count: 0)
    @State var item = TVShowModel(title: "TVShow", director: "Dostan", count: 10)
    //теперь у нас есть еще однв модел которая ссылается на главную MovieModel
    
    var body: some View {
        VStack{
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
    }
}


#Preview {
    tView()
}
