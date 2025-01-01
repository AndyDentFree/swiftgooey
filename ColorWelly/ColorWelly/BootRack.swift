//
//  BootRack.swift
//  ColorWelly
//
//  Created by Andrew Dent on 1/1/2025.
//

import SwiftUI

struct BootRack: View {
    @Binding var row1: Color
    @Binding var row2: Color
    var otherHeading: String
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad
    @State var scratchEntry: String = ""

    var body: some View {
        Grid(alignment: .centerFirstTextBaseline, verticalSpacing: 12) {
            GridRow() {
                Text("Boots")
                    .gridColumnAlignment(.trailing)
                
                Text("Picker")
                    .gridColumnAlignment(.leading)
                
                Text(otherHeading)  // original has three columns
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
            GridRow {
                Text("Tapping in the text entry field above will cause an onscreen keyboard to appear. We want to be able to tap any whitespace area to dismiss that.")
                // context of the original problem is using numeric keyboards that lack a Done option to dismiss, so tapping needed
                    .gridCellColumns(3)
            }
        }  // Grid
    }
}


struct Bootrack_Previews: PreviewProvider {
    static var previews: some View {
        @State var row1 = Color.pink
        @State var row2 = Color.purple
        @FocusState var previewFocus: Int?
        return     BootRack(row1: $row1, row2: $row2, otherHeading: "blah", focTag: $previewFocus)
    }
}
