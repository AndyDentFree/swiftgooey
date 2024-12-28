//
//  ContentView.swift
//  ColorWelly
//
//  Created by Andrew Dent on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State var row1 = Color.green
    @State var row2 = Color.blue
    @State var row3 = Color.pink
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad

    // repeat a few variations on picker configuration to replicate something
    // like my original problem app
    var body: some View {
        ScrollView {
            Grid(alignment: .centerFirstTextBaseline, verticalSpacing: 12) {
                GridRow() {
                    Text("Preview")
                    Text("Picker")
                    Text("Other column")  // original has three columns
                        .font(.body)
                }.font(.title2)
                
                GridRow(alignment: .center) {
                    BootView(bootColor: $row1)
                        .gridColumnAlignment(.trailing)
                        .frame(width: 80, height: 120)
                    ColorPicker("", selection: $row1)
                        .focused($focTag, equals: 1)
                        .labelsHidden() // vital to stop right-alignment
                        .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                        .gridCellColumns(2)
                }
                
                GridRow(alignment: .center) {
                    BootView(bootColor: $row2)
                        .frame(width: 80, height: 120)
                    HStack {
                        ColorPicker("", selection: $row2)
                            .focused($focTag, equals: 2)
                            .labelsHidden() // vital to stop right-alignment
                            .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                        Spacer()
                            .onTapGesture {
                                focTag = nil
                            }
                    }
                        .gridCellColumns(2)
                }
                Divider()
                GridRow(alignment: .center) {
                    BootView(bootColor: $row3)
                        .frame(width: 80, height: 120)
                        .contentShape(Rectangle()) // Ensures the whole cell is tappable
                        .onTapGesture {
                            focTag = nil
                        }
                    HStack {
                        ColorPicker("", selection: $row3)
                            .focused($focTag, equals: 3)
                            .labelsHidden() // vital to stop right-alignment
                            .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                        Spacer()
                            .onTapGesture {
                                focTag = nil
                            }
                    }
                        .gridCellColumns(2)
                }
            }
        }
    }
}


struct Content_Previews: PreviewProvider {
    static var previews: some View {
        @FocusState var previewFocus: Int?
        return ContentView(focTag: $previewFocus)
    }
}

