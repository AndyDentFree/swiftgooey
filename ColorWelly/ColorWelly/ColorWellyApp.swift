//
//  ColorWellyApp.swift
//  ColorWelly
//
//  Created by Andrew Dent on 25/12/2024.
//

import SwiftUI

@main
struct ColorWellyApp: App {
    @FocusState var mainFocus: Int?
    var body: some Scene {
        WindowGroup {
            ContentView(focTag: $mainFocus)
        }
    }
}
