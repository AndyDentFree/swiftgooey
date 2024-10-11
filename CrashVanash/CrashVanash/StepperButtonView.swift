//
//  StepperButtonView.swift
//  Purrticles
//
//  Created by Andrew Dent on 17/9/2024.
//

import SwiftUI

fileprivate func stepperLabel(isDown: Bool) -> some View {
    if isDown {
        Text("-")
            .font(.title2)
            .foregroundColor(.primary) // Same color as the central text
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity,alignment: .leading)
            .padding(.leading, 16)

    } else {
        Text("+")
            .font(.title2)
            .foregroundColor(.primary) // Same color as the central text
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity,alignment: .trailing)
            .padding(.trailing, 16)

    }
}

struct StepperButtonView: View {
    let isDown: Bool
    let action: ()->Void
    
    #if os(macOS)
    var body: some View {
        if #available(macOS 14,*) {
            Button(action: action) {
                stepperLabel(isDown: isDown)
            }
            .buttonStyle(.plain)
            .buttonRepeatBehavior(.enabled)
        } else {
            //TODO: https://bitbucket.org/touchgram/purrticles/issues/60/targeting-earlier-macos-for-m1-air-had-to
            // want an alternative way to repeat - check ChatGPT
            Button(action: action) {
                stepperLabel(isDown: isDown)
            }
            .buttonStyle(.plain)
        }
        
        }
    #else
    var body: some View {
        if #available(iOS 17,*) {
        Button(action: action) {
            stepperLabel(isDown: isDown)
        }
            .buttonStyle(.plain)
            .buttonRepeatBehavior(.enabled)
        } else {
            Button(action: action) {
                stepperLabel(isDown: isDown)
            }
            .buttonStyle(.plain)
        }
    }
    #endif
}

#Preview {
    HStack{
        Rectangle()
            .frame(width: 40, height: 40)
        StepperButtonView(isDown: true) {print("pushed")}
            .background(Color.pink)
    }
    
}
