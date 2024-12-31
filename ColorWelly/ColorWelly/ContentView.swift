//
//  ContentView.swift
//  ColorWelly
//
//  Created by Andrew Dent on 25/12/2024.
//

import SwiftUI


// use on a Grid eg:
// .modifier(GridOverallTap(tapAction: { focTag = nil }))
struct GridOverallTap: ViewModifier {
    let tapAction: ()->()
    
#if os(iOS)
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            return content
                .contentShape(Rectangle()) // Ensures the whole row is tappable
                .onTapGesture {
                    tapAction()
                }
        } else {  // only added in iOS18 onwards
            return content
        }
    }
    
#else
    func body(content: Content) -> some View {
        content
    }
#endif
}


struct ContentView: View {
    @State var row1 = Color.green
    @State var row2 = Color.blue
    @State var scratchEntry: String = ""
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad
    @State private var controlsTabSelection = 1  // start on controls, also used to pick control mode in landscape
    
    // repeat a few variations on picker configuration to replicate something
    // like my original problem app
    var body: some View {
        ScrollView {
            Grid(alignment: .centerFirstTextBaseline, verticalSpacing: 12) {
                GridRow() {
                    Text("Boots")
                        .gridColumnAlignment(.trailing)
                    
                    Text("Picker")
                        .gridColumnAlignment(.leading)
                    
                    Text("Other column")  // original has three columns
                        .font(.body)
                        .gridColumnAlignment(.leading)
                }.font(.title2)
                
                GridRow(alignment: .center) {
                    BootView(bootColor: $row1)
                        .frame(width: 80, height: 120)
                    ColorPicker("", selection: $row1)
                        .focused($focTag, equals: 1)  // has no effect
                        .labelsHidden() // vital to stop right-alignment
                        .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                        .gridCellColumns(2)
                }
                
                GridRow(alignment: .center) {
                    BootView(bootColor: $row2)
                        .frame(width: 80, height: 120)
                    HStack {
                        ColorPicker("", selection: $row2)
                            .focused($focTag, equals: 2) // has no effect
                            .labelsHidden() // vital to stop right-alignment
                            .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                        Spacer()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focTag = nil
                            }
                    }
                    .gridCellColumns(2)
                }
                Divider()
                GridRow {
                    Text("Enter")
                    Text("to see keyboard ")
                    TextField("scratch", text: $scratchEntry)
                        .focused($focTag, equals: 99)
                }
            }  // Grid
            .modifier( GridOverallTap(tapAction: {
                focTag = nil
                var focMsg = "no focus"
                if let prevFoc = focTag {
                    focMsg = "most recent focus is \(prevFoc)"
                }
                print("tap action on grid triggered. " + focMsg)
            }) )
        } // scroll
        .frame(maxWidth: .infinity)  // fill rest of width
    }
}


struct Content_Previews: PreviewProvider {
    static var previews: some View {
        @FocusState var previewFocus: Int?
        return ContentView(focTag: $previewFocus)
    }
}
