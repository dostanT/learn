//
//  TimerTask.swift
//  learn
//
//  Created by Dostan Turlybek on 22.04.2025.
//

import SwiftUI


class TimerTaskViewModel: ObservableObject {
    @Published var counter = 0
    var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.counter += 1
            print("Counter: \(self?.counter ?? 0)")
        }
    }

    deinit {
        print("💀 TimerManager уничтожен")
    }
}


struct TimerTaskView: View {
    @State private var manager: TimerTaskViewModel? = TimerTaskViewModel()

        var body: some View {
            VStack {
                Text("Counter: \(manager?.counter ?? 0)")
                    .font(.largeTitle)
                HStack {
                    Button("Start Timer") {
                        manager?.startTimer()
                    }
                    Button("Delete Timer") {
                        manager = nil
                    }
                }
            }
        }
}
#Preview {
    TimerTaskView()
}
