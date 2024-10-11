//
//  ContentView.swift
//  CrashVanash
//
//  Created by Andrew Dent on 11/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State var count: Int = 10

    var body: some View {
        VStack {
            Text("CrashVanash!")
                .font(.largeTitle)
            Spacer()
            Button("Reset Count") {
                count = 10
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Text("Button vanishes when hits zero, holding down on\n+/- to repeat should trigger the crash")
            Spacer()
                .frame(height: 20)
            if count > 0 {
                StepperNumView<Int>(title: "Count, tap centre to edit", value: $count, step: 1)
                    .padding(.horizontal)
            } else {
                Text("Button vanished with invalid count")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
