//
//  ContentView.swift
//  CrashVanash
//
//  Created by Andrew Dent on 11/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State var count: Int = 10
    @State var countu: UInt = 10
    @State var countuNonVanishing: UInt = 10
    @FocusState var focTag: ControlFocusTag?  // used to hide numeric keypad


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
            Text("Button vanishes when hits zero, holding down on\n+/- to repeat should trigger weird things")
            Spacer()
                .frame(height: 20)
            if count > 0 {
                StepperNumView<Int>(title: "Count, tap centre to edit", tag: .count, value: $count, step: 1, focusedTag: $focTag)
                    .padding(.horizontal)
            } else {
                Text("Button vanished with zero count")
            }
            Spacer()
            Text("""
                Button vanishes when hits zero
                on auto-repeat '-' button
                and APP CRASHES
                """)
            if countu > 0 {
                StepperNumView<UInt>(title: "Unsigned", tag: .unsignedCount, value: $countu, step: 1, focusedTag: $focTag)
                    .padding(.horizontal)
            } else {
                Text("Button vanished with zero count")
            }
            Spacer()
            Text("Won't crash, just stops at zero as button is disabled")
            StepperNumView<UInt>(title: "Unsigned non-crashing", tag: .unsignedCountNonVanish, value: $countuNonVanishing, step: 1, focusedTag: $focTag)
                .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
