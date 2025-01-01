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

// little helper so labels in ContentView indicate expected behaviour
#if os(iOS)
func backgroundTappable() -> Bool {
    if #available(iOS 18.0, *) {
        return true
    } else {
        return false
    }
}
#else
func backgroundTappable() -> Bool {
    true
}
#endif



struct ContentView: View {
    @State var row1 = Color.green
    @State var row2 = Color.blue
    @FocusState.Binding var focTag: Int?  // used to hide numeric keypad
    @State private var demoTabSelection = 1
    
    
    var body: some View {
        VStack {
            Text("Choose a tab to see the bug on iPadOS 16 & 17, a 'fix' which loses background taps to dismiss the keyboard or, hopefully, a general fix")
            Spacer()
            Picker("", selection: $demoTabSelection) {
                Text("Bug on older OS").tag(1)
                Text("No dismiss older OS").tag(2)
                Text("Final Fix").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            ScrollView {
                switch demoTabSelection {
                case 1:
                    BootRack(row1: $row1, row2: $row2, otherHeading: "tap to dismiss keyboard", focTag: $focTag)
                        .contentShape(Rectangle()) // Ensures the whole row is tappable
                        .onTapGesture {  // prevents ColorPickers working on iPadOS 16 & 17
                            focTag = nil
                            print("Tap action on grid triggered, in mode where ColorPicker doesn't work on iPadOS 16 & 17.")
                        }
                case 2:
                    BootRack(row1: $row1, row2: $row2, otherHeading: backgroundTappable() ? "tappable as OS 18" : "untappable", focTag: $focTag)
                        .modifier( GridOverallTap(tapAction: {
                            focTag = nil
                            var focMsg = "no focus"
                            if let prevFoc = focTag {
                                focMsg = "most recent focus is \(prevFoc)"
                            }
                            print("Tap action on grid triggered. " + focMsg)
                        }) )
                default:
                    BootRackPerAreaTappable(row1: $row1, row2: $row2, otherHeading: "Tappable by row", focTag: $focTag, bgndTapAction: {focTag = nil})
                }  // tab switch
            } // scroll
            .padding(.horizontal)
        }  // VStack inc tabs
        .frame(maxWidth: .infinity)  // fill rest of width
    }
}


struct Content_Previews: PreviewProvider {
    static var previews: some View {
        @FocusState var previewFocus: Int?
        return ContentView(focTag: $previewFocus)
    }
}
