//
//  ContentView.swift
//  CrashVanash
//
//  Created by Andrew Dent on 11/10/2024.
//

import SwiftUI

struct ContentView: View {
    @FocusState var focTag: ControlFocusTag?  // used to hide numeric keypad
    @Binding var vm: TinyDoc

    var body: some View {
        VStack {
            Text("CrashVanash!")
                .font(.largeTitle)
            Spacer()
            Button("Reset Count") {
                vm.reset()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Text("""
            Button vanishes when hits zero, holding down on
            +/- to repeat should trigger weird things
            
            hold it down for long enough that accelerates change
            """
            )
            .multilineTextAlignment(.center)
            Spacer()
                .frame(height: 20)
            if vm.count > 0 {
                StepperNumView<Int>(title: "Count, tap centre to edit", tag: .count, value: $vm.count, step: 1, focusedTag: $focTag)
                    .padding(.horizontal)
            } else {
                Text("Button vanished hitting zero")
            }
            if vm.ucount > 0 {
            Spacer()
            StepperNumView<UInt>(title: "Usigned", tag: .unsignedCount, value: $vm.ucount, step: 1, focusedTag: $focTag)
                .padding(.horizontal)
            } else {
                Text("Button vanished hitting zero")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView(vm: .constant(TinyDoc()))
}
