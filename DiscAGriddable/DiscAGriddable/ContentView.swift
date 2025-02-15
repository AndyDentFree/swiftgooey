//
//  ContentView.swift
//  DiscAGriddable
//
//  Created by Andrew Dent on 14/2/2025.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("controlsExpanded") private var controlsExpanded: Bool = true
    @AppStorage("formattingExpanded") private var formattingExpanded: Bool = true
    @State private var stepperWidth: CGFloat = 40  // To store the measured width of the stepper
    @ScaledMetric var controlSpacing: CGFloat = 12.0
    
    // fake states instead of original doc
    @State private var useSpaces = true
    
    var body: some View {
        ScrollView(.vertical) {
            HStack(spacing: 0) {
                DisclosureGroup("Formatting", isExpanded: $formattingExpanded) {
                    Grid(alignment: .leading, verticalSpacing: controlSpacing) {
                        GridRow {
                            Text("Indent with spaces")
                            //Spacer()  // this is the CAUSE OF THE PROBLEM!
                            Toggle("", isOn: $useSpaces)
                                .gridColumnAlignment(.trailing)
                        }
                    } // Grid
                    .padding(.horizontal)
                }  // Formatting group
                .padding(.horizontal, 4)
                Rectangle()
                    .fill(.pink)
                    .frame(width: 8, height: .infinity)
                Circle()
                    .fill(.green)
                    .frame(width: 40)
            }  // HStack
        }  // scroll
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
