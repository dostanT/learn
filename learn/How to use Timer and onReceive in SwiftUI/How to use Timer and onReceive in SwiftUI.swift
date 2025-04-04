//
//  How to use Timer and onReceive in SwiftUI.swift
//  learn
//
//  Created by Dostan Turlybek on 04.04.2025.
//

import SwiftUI

class HowToUseTimerAndOnReceiveInSwiftUIViewModel: ObservableObject {
    
}

struct HowToUseTimerAndOnReceiveInSwiftUIView: View {
    
    @StateObject var vm: HowToUseTimerAndOnReceiveInSwiftUIViewModel = .init()
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect() // publisher который передаст значение
    // .autoconnect() начанает отсчет сразу же как только инициализируется HowToUseTimerAndOnReceiveInSwiftUIView
    
    
    //Current Time
    /*
    @State var currentDate: Date = Date()
    var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
     */
    
    //Countdown
    /*
    @State var count: Int = 5
    @State var finishedText: String? = nil
    */
    
    //Countdown to date
    /*
    @State var timerRemaining: String = ""
    let futureDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    
    func updateTimeRemaining(){
        //эта функция нужна для того что бы высчитовать разницу между futureDate и timerRemaining
        let remaining =  Calendar.current.dateComponents([.hour, .minute, .second],
                                                         from: Date(),
                                                         to: futureDate)
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timerRemaining =  "\(hour)h : \(minute)m : \(second)s"
    }
    */
    
    //Animation counter
    @State var count: Int = 0
    
    var body: some View {
        ZStack{
            RadialGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))]),
                center: .center,
                startRadius: 5,
                endRadius: 500)
            .ignoresSafeArea()
            
            TabView(selection: $count) {
                Rectangle()
                    .foregroundStyle(.red)
                    .tag(0)
                Rectangle()
                    .foregroundStyle(.purple)
                    .tag(1)
                Rectangle()
                    .foregroundStyle(.black)
                    .tag(2)
                Rectangle()
                    .foregroundStyle(.yellow)
                    .tag(3)
                Rectangle()
                    .foregroundStyle(.blue)
                    .tag(4)
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle())
            .padding()
        }
//        .onReceive(timer /*тут получает*/) { value in // subscriber тут присваивает
//            currentDate = value// subscriber тут присваивает
//        }// subscriberтут присваивает
        
//        .onReceive(timer) { _ in
//            if count < 1 {
//                finishedText = "Wow!!"
//            }
//            else{
//                count -= 1
//            }
//        }
//        .onReceive(timer) { _ in
//            updateTimeRemaining()
//        }
        .onReceive(timer) { _ in
            withAnimation (.easeInOut) {
                count = (count + 1) % 5
            }
        }
    }
}


