//
//  Accessibility in Swift Dynamic Colors.swift
//  learn
//
//  Created by Dostan Turlybek on 14.04.2025.
//


//Open DisplayAndTextSize

import SwiftUI
//open developer tool in Xcode tab bar
// then you need to open from window Color Contrast Calculator
// color contrast ratio need to google it and find good ratio
// there are need to because some one cant read text, they cant see the text, cant to differ color. We can check what color pallete are confortable for a lot people and just use it for great reading
// in test first number should be greater than secnond 15-20 times for cool result

struct Accessibility_in_Swift_Dynamic_Colors: View {
    
    //In the iPhone or iPad we have switches like Reduce Transparency. People who can't differentiate certain colors use it to signal to developers that they need more accessible color schemes — with higher contrast, clearer labels, or additional indicators beyond just color. This helps developers make apps that are inclusive for users with visual impairments or color blindness.
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    
    //In SwiftUI, we can use @Environment(\.colorSchemeContrast) to detect whether the user has enabled Increased Contrast in Accessibility settings. This allows developers to adapt the UI accordingly — for example, by increasing contrast between text and background, adding clearer borders, or avoiding semi-transparent elements — ensuring the app is more readable and usable for people with visual impairments.
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    
    var body: some View {
        NavigationStack{
            VStack{
                Button("Button 1"){
                    
                }
                .foregroundStyle(colorSchemeContrast == .increased ? .white : .primary)
                .buttonStyle(.borderedProminent)
                
                Button("Button 1"){
                    
                }
                .foregroundStyle(.primary)
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button("Button 1"){
                    
                }
                .foregroundStyle(.primary)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button("Button 1"){
                    
                }
                .foregroundStyle(.primary)
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
            .font(.largeTitle)
            .navigationTitle(Text("HI"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(reduceTransparency ? Color.black : Color.black.opacity(0.5))
        }
    }
}

#Preview {
    Accessibility_in_Swift_Dynamic_Colors()
}
