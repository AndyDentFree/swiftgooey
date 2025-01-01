//
//  BootRackPerAreaTappable.swift
//  ColorWelly
//
//  Created by Andrew Dent on 1/1/2025.
//


import SwiftUI

struct BootRackPerAreaTappable: View {
    @Binding var row1: Color
    @Binding var row2: Color
    var otherHeading: String
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad
    let bgndTapAction: ()->()
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
            .onTapGesture {
                bgndTapAction()
            }
            
            GridRow(alignment: .center) {
                BootView(bootColor: $row1)
                    .frame(width: 80, height: 120)
                    .background(Color.gray.opacity(0.3))
                ZStack {
                    Color(.systemBackground)  // cannot use .clear here to be able to tap
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                        .onTapGesture {
                            bgndTapAction()
                        }
                    ColorPicker("", selection: $row1)
                        .focused($focTag, equals: 1)  // has no effect
                        .labelsHidden() // vital to stop right-alignment
                        .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                }
                .gridCellColumns(2)
            }
            
            GridRow(alignment: .center) {
                BootView(bootColor: $row2)
                    .frame(width: 80, height: 120)
                    .background(Color.gray.opacity(0.3))
                ZStack {
                    Color(.systemBackground)  // cannot use .clear here to be able to tap
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                        .onTapGesture {
                            bgndTapAction()
                        }
                    ColorPicker("", selection: $row2)
                        .focused($focTag, equals: 2) // has no effect
                        .labelsHidden() // vital to stop right-alignment
                        .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                }
                .gridCellColumns(2)
            }
            Divider()
            GridRow {
                Text("Enter to see keyboard ")
                    .gridColumnAlignment(.leading)
                    .gridCellColumns(2)
                    .onTapGesture {
                        bgndTapAction()
                    }
                TextField("scratch", text: $scratchEntry)
                    .gridColumnAlignment(.leading)
                    .focused($focTag, equals: 99)
            }
            GridRow() {
                Spacer()
                    .frame(width: 1, height: 1)  // min spec Spacer just to ensure column used, width of column comes from other content above, height by wrapping Text
                Text("Tapping in the text entry field above will cause an onscreen keyboard to appear. We want to be able to tap any whitespace area to dismiss the keyboard")
                    .gridCellAnchor(.topLeading)
                    .gridCellColumns(2)  // really doesn't want to make it across entire row, 3 causes weird layout as if extra column
                    .fixedSize(horizontal: false, vertical: true)  // wraps as needed
                    .multilineTextAlignment(.leading)
            }
            .onTapGesture {
                bgndTapAction()
            }
        }  // Grid
    }
}
