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
    @State private var sampleText = """
    I wish that I could always see
    my code as lovely as a tree
    in subtle breeze, with sunlight wove
    a symphony, across the grove.

    Yet ugly leaks and bugs do mar
    ambitious grace - squint from afar.
    The bramble hell of versioned phones
    stabs and tangles, then hides my bones.
    """
    
    var body: some View {
        ScrollView {
            VStack {
                DisclosureGroup("Export settings", isExpanded: $controlsExpanded) {
                    
                    VStack(alignment: .leading, spacing: controlSpacing) {
                        Spacer()
                        DisclosureGroup("Formatting", isExpanded: $formattingExpanded) {
                            Grid(alignment: .leading, verticalSpacing: controlSpacing) {
                                GridRow {
                                    Text("Indent with spaces")
                                    Spacer()
                                    Toggle("", isOn: $useSpaces)
                                    .gridColumnAlignment(.trailing)
                                }
                            } // Grid
                            .padding(.horizontal)
                        }  // Formatting group
                        .padding(.horizontal, 4)
                    }
                }  // disclosure
                Spacer()
                    .frame(height: 40.0)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 2.0)
                
                Spacer()
                    .frame(height: 20.0)
                Text(sampleText)  // dependency implied on dirty flag from changing emitter params
                    .textSelection(.enabled)
            } // outer VStack
            .padding()
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
