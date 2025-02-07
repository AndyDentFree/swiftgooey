//
//  Untitled.swift
//  Docundoable
//
//  Created by Andy Dent on 6/2/2025.
//

import SwiftUI

struct EditMenuCommands: Commands {
    @FocusedBinding(\.activeDocument) var document // from ContentView
    
    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            Button(action: {
                document?.undo()
            }) {
                Text(document?.undoMenuItemTitle ?? "")
            }
            .disabled(!(document?.canUndo ?? false))
            Button(action:  {
                document?.redo()
            }) {
                Text(document?.redoMenuItemTitle ?? "")
            }
            .disabled(!(document?.canRedo ?? false))
        }
    }
}

struct ActiveDocumentKey: FocusedValueKey {
    typealias Value = Binding<DocundoableDocument>
}

extension FocusedValues {
    var activeDocument: ActiveDocumentKey.Value? {
    get { self[ActiveDocumentKey.self] }
    set { self[ActiveDocumentKey.self] = newValue }
  }
}

