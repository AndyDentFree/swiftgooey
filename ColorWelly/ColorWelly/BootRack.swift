//
//  BootRack.swift
//  ColorWelly
//
//  Created by Andy Dent on 1/1/2025.
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
                    .background(Color.gray.opacity(0.1))
                    .gridColumnAlignment(.trailing)
                
                Text("Picker")
                    .gridColumnAlignment(.leading)
                
                Text(otherHeading)  // original has three columns
                    .font(.body)
                    .gridColumnAlignment(.leading)
            }
            .font(.title2)
            
            GridRow(alignment: .center) {
                BootView(bootColor: $row1)
                    .frame(width: 80, height: 120)
                    .background(Color.gray.opacity(0.3))
                ColorPicker("", selection: $row1)
                    .focused($focTag, equals: 1)  // has no effect
                    .labelsHidden() // vital to stop right-alignment
                    .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                    .gridCellColumns(2)
            }
            
            GridRow(alignment: .center) {
                BootView(bootColor: $row2)
                    .frame(width: 80, height: 120)
                    .background(Color.gray.opacity(0.3))
                HStack {
                    ColorPicker("", selection: $row2)
                        .focused($focTag, equals: 2) // has no effect
                        .labelsHidden() // vital to stop right-alignment
                        .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                    Spacer()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            focTag = nil
                            print("HStack next to 2nd ColorPicker tapped")
                        }
                }
                .gridCellColumns(2)
            }
            Divider()
            GridRow {
                Text("Enter to see keyboard ")
                    .gridCellColumns(2)
                TextField("scratch", text: $scratchEntry)
                    .focused($focTag, equals: 99)
            }
            
            GridRow(alignment: .top) {
                Spacer()
                    .frame(width: 1, height: 1)  // min spec Spacer just to ensure column used, width of column comes from other content above, height by wrapping Text
                Text("Tapping in the text entry field above will cause an onscreen keyboard to appear. We want to be able to tap any whitespace area to dismiss the keyboard")
                    .gridCellAnchor(.topLeading)
                    .gridCellColumns(2)  // really doesn't want to make it across entire row, 3 causes weird layout as if extra column
                    .fixedSize(horizontal: false, vertical: true)  // wraps as needed
                    .multilineTextAlignment(.leading)
            }
            // context of the original problem is using numeric keyboards that lack a Done option to dismiss, so tapping needed
        }  // Grid
    }
}


// copy of BootRack but special GridRow


struct Bootrack_Previews: PreviewProvider {
    static var previews: some View {
        @State var row1 = Color.pink
        @State var row2 = Color.purple
        @FocusState var previewFocus: Int?
        return     BootRack(row1: $row1, row2: $row2, otherHeading: "blah", focTag: $previewFocus)
    }
}
