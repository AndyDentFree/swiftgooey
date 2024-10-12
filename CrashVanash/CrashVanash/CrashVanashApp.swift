//
//  CrashVanashApp.swift
//  CrashVanash
//
//  Created by Andrew Dent on 11/10/2024.
//

import SwiftUI

@main
struct CrashVanashApp: App {
    @State var doc = TinyDoc()
    var body: some Scene {
        WindowGroup {
            ContentView(vm: $doc)
        }
    }
}
