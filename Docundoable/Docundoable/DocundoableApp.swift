//
//  DocundoableApp.swift
//  Docundoable
//
//  Created by Andy Dent on 30/1/2025.
//

import SwiftUI

@main
struct DocundoableApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: DocundoableDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands{
            // mostly for macOS
            EditMenuCommands()
        }
    }
}
