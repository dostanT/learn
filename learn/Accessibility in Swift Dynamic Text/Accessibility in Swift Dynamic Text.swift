//
//  Accessibility in Swift Dynamic Text.swift
//  learn
//
//  Created by Dostan Turlybek on 14.04.2025.
//

import SwiftUI

struct Accessibility_in_Swift_Dynamic_Text: View {
    
    @Environment(\.sizeCategory) var sizeCategory //когда у юзера слишком маленький шрифт. Он становится еще меньше на столько что его не видно. Можно преодолеть этот барьер при помощи sizeCategory
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(0..<10){i in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack{
                            Image(systemName: "heart.fill")
                            Text("Dynamic Text \(i)")
                        }
                        .font(.title)
                        Text("This is some longer text that goes on and on and on.")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(3)
                            .minimumScaleFactor(/*sizeCategory == .accessibilityExtraLarge ? 0.8 : 1.0*/ sizeCategory.customMinScaleFactor) // задает значение до которого может уменьшится текст процентно
                    }
//                    .frame(height: 100) // проблема в точек в том что тут фиксированная высота и вообщем рамочка. Без нее текст станет нормальным и читабельным
                    .background(.cyan)
//                    .truncationMode(.head) // положение точек в конце если текст не вмещяется
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Dynamic text")
        }
    }
}

#Preview {
    Accessibility_in_Swift_Dynamic_Text()
}

/*
 public enum ContentSizeCategory : Hashable, CaseIterable {

     case extraSmall

     case small

     case medium

     case large

     case extraLarge

     case extraExtraLarge

     case extraExtraExtraLarge

     case accessibilityMedium

     case accessibilityLarge

     case accessibilityExtraLarge

     case accessibilityExtraExtraLarge

     case accessibilityExtraExtraExtraLarge

 */

extension ContentSizeCategory{
    
    var customMinScaleFactor: CGFloat{
        switch self {
        case .extraSmall, .small, .medium:
            return 1.0
        case .large, .extraLarge, .extraExtraLarge:
            return 0.8
        default :
            return 0.6
        }
    }
}
