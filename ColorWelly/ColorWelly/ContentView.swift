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


// this relates to the Purrticles app combination of
// Main DocWindow, containing
// - PreviewView (contains a SpriteKit SKView as a UIViewRepresentable)
// - StandardParticleControlsView

struct ContentView: View {
    @State var common = Color.yellow
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad
    @State private var controlsTabSelection = 1  // start on controls, also used to pick control mode in landscape
    
    // repeat a few variations on picker configuration to replicate something
    // like my original problem app
    var body: some View {
        GeometryReader { geometry in
            Group {
                HStack(spacing: 0) {
                    // one big boot to side of scroller, replicates Purrticles having a SpriteKit hosted here
                    BootView(bootColor: $common)
                        .frame(width: geometry.size.width * (geometry.size.isLandscape ? 0.6 : 0.4))
                    
                    // tabs (which are not actually active) above scrolling controls
                    VStack {
                        Spacer()
                        Picker("", selection: $controlsTabSelection) {
                            Text("Applied").tag(0)
                            Text("Xcode").tag(1)
                            Text("Full").tag(2)
                            Image(systemName: "note.text").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        Spacer()
                        
                        ScrollView {
                            Grid(alignment: .centerFirstTextBaseline, verticalSpacing: 12) {
                                GridRow() {
                                    Text("Labels")
                                        .gridColumnAlignment(.trailing)
                                    
                                    Text("Picker")
                                        .gridColumnAlignment(.leading)
                                    
                                    Text("Other column")  // original has three columns
                                        .font(.body)
                                        .gridColumnAlignment(.leading)
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
                                        .contentShape(Rectangle()) // Ensures the whole cell is tappable
                                        .onTapGesture {
                                            focTag = nil
                                        }
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
                                Divider()
                                GridRow(alignment: .center) {
                                    ControlLabelView(title: "Row last")
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
                            }  // Grid
                            }
                        } // scroll
                    } // VStack with tabs around scroller
                    .frame(maxWidth: .infinity)  // fill rest of width
                } // top HStack
            }  // Group
        } // top GeometryReader
        
    }
}


struct Content_Previews: PreviewProvider {
    static var previews: some View {
        @FocusState var previewFocus: Int?
        return ContentView(focTag: $previewFocus)
    }
}


extension CGSize {
    public var isLandscape: Bool {get{ width > height}}
}
