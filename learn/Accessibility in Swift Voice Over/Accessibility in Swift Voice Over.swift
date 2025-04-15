//
//  Accessibility in Swift Voice Over.swift
//  learn
//
//  Created by Dostan Turlybek on 15.04.2025.
//

import SwiftUI

struct Accessibility_in_Swift_Voice_Over: View {
    
    @State private var isActive: Bool = false
    @State private var isFavorite: Bool = true
    
    var body: some View {
        NavigationStack{
            Form {
                //Прикол в том что когда я на Voice Over чекаю что тут вообще написано, на Toggle мне говрит что есть Volume и кнопка которой я могу пользовтся, а HStack просто говрит что есть Volume без кнопки. Потому что Voice Over не понимает есть ли там копнка, нету, как пользоватся ей. до изменение (1) (2)
                Section{
                    Toggle(isOn: $isActive) {
                        Text("Volume")
                    }
                    
                    HStack{
                        Text("Volume")
                        Spacer()
                        Text(isActive ? "ON" : "OFF")
                            .accessibilityHidden(true) //БУДЕТ ЧИТАТЬ ТО ЧТО НА .accessibilityValue(isActive ? "is on" : "is off")
                    }
                    .background(.black.opacity(0.0000001))//nice trick
                    .onTapGesture {
                        isActive.toggle()
                    }
                    .accessibilityElement(children: .combine) //(1) теперь все елементы сгрупирированы и Voice Over будет читать весь текст который активный в интерфейсе. Но мы еще не сказали юзеру то что это кнопка и как ей пользоватся. До изменение (2)
                    .accessibilityAddTraits(.isButton ) // (2) мы говором Voice Over то что это кнопка. Оно говорт что это просто кнопка, а как ей пользоватся не говорится. До изменения (3)
                    .accessibilityValue(isActive ? "is on" : "is off")
                    .accessibilityHint("Double tap to toggle setting") // (3) теперь оно озвучивает условие пользование
                    .accessibilityAction {
                        isActive.toggle( )
                    }
                } header: {
                    Text("PREFERENCES")
                }
                
                Section{
                    Button{
                        isFavorite.toggle()
                    } label: {
                        Text("Favorites")
                    }
                    
                    Button{
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                    
                    Text("Favotites")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.black.opacity(0.00000001))
                        .onTapGesture{
                            isFavorite.toggle()
                        }

                } header:{
                    Text("APPLICATION")
                }
                
                VStack{
                    Text("CONTENT")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 8) {
                            ForEach(0..<10){x in
                                VStack{
                                   Image("girl")
                                        .resizable()
                                        .scaledToFit( )
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    Text("Item \(x)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Accessibility_in_Swift_Voice_Over()
}
