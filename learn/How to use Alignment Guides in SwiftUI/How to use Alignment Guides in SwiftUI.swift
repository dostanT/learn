//
//  How to use Alignment Guides in SwiftUI.swift
//  learn
//
//  Created by Dostan Turlybek on 17.04.2025.
//

import SwiftUI

struct How_to_use_Alignment_Guides_in_SwiftUI: View {
    //Когда мы используем padding() или offset оно сдвинет за оранжевую но взади бекгроунд не окрасится. но я хочу что бы оранжевый был с зади всего текста даже того который сдвинулся. для этого нужно использовать .alignmentGuide(T##g: HorizontalAlignment##HorizontalAlignment, computeValue: T##(ViewDimensions) -> CGFloat)
    var body: some View {
        VStack(alignment: .leading){
            Text("Hello, World!")
                .background(.blue)
                .alignmentGuide(.leading) { dimensions in
                    return 49
                }
            
            Text("This is some other text")
                .background(.red)
        }
        .background(.orange)
    }
}


// тут я хочу что бы у некоторых были иконки а у некотрых что бы не были
struct AlignmentChildView: View {
    var body: some View{
        VStack(alignment: .leading, spacing: 20){
            row(title: "Row 1", showIcon: false)
            row(title: "Row 2", showIcon: true)
            row(title: "Row 3", showIcon: false)
        }
        .padding(16)
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(40)
        
        
    }
    
    private func row(title: String, showIcon: Bool) -> some View{
        HStack(spacing: 10){
            if showIcon{
                Image(systemName: "info.circle")
                    .frame(width: 30, height: 30)
                
            }
            Text(title)
            Spacer()
        }
        .background(.red)
        .alignmentGuide(.leading) { dimension in
            return showIcon ? 40 : 0 // 40 = width(30) + spacing(10)
        }
    }
}

#Preview {
    AlignmentChildView()
}
