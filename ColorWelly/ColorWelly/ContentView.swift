//
//  ContentView.swift
//  ColorWelly
//
//  Created by Andrew Dent on 25/12/2024.
//

import SwiftUI


struct ControlLabelView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .gridColumnAlignment(.trailing)
            .font(.subheadline)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
    }
}



struct ContentView: View {
    // MAYBE NEED TO USE MY EXACT LEADING LABEL TYPE HERE
    @State var common = Color.yellow
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad

    // repeat a few variations on picker configuration to replicate something
    // like my original problem app
    var body: some View {
        /*GeometryReader { geometry in
            Group {*/
                HStack(spacing: 0) {
                    // one big boot to side of scroller, replicates Purrticles having a SpriteKit hosted here
                    BootView(bootColor: $common)
                        .frame(width: 400/*geometry.size.width/0.3*/)
                    
                    ScrollView {
                        Grid(alignment: .centerFirstTextBaseline, verticalSpacing: 12) {
                            GridRow() {
                                Text("Preview")
                                Text("Picker")
                                Text("Other column")  // original has three columns
                                    .font(.body)
                            }.font(.title2)
                            
                            GridRow(alignment: .center) {
                                ControlLabelView(title: "Row1")
                                ColorPicker("", selection: $common)
                                    .focused($focTag, equals: 1)
                                    .labelsHidden() // vital to stop right-alignment
                                    .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, alignment: .leading) // left-aligns instead of centred
                                    .gridCellColumns(2)
                            }
                            
                            GridRow(alignment: .center) {
                                ControlLabelView(title: "Row2")
                                HStack {
                                    ColorPicker("", selection: $common)
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
                                ControlLabelView(title: "Row3")
                                HStack {
                                    ColorPicker("", selection: $common)
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
                    } // scroll
                    .frame(maxWidth: .infinity)  // fill rest of width
                } // top HStack
           /* }  // Group
        } // top GeometryReader
            */
    }
}


struct Content_Previews: PreviewProvider {
    static var previews: some View {
        @FocusState var previewFocus: Int?
        return ContentView(focTag: $previewFocus)
    }
}

