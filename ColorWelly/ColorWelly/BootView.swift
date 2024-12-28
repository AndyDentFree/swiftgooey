//
//  BootView.swift
//  ColorWelly
//
//  Created by Andrew Dent on 25/12/2024.
//

import SwiftUI

struct BootView: View {
    @Binding var bootColor: Color
    var body: some View {
        WellyBoot()
            .fill(bootColor) // Fill with the selected color
            .padding()
    }
}

#Preview {
    BootView(bootColor: .constant(.green))
}
