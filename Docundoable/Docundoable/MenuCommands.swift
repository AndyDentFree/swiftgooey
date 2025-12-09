//
//  MenuCommands.swift
//  Docundoable
//
//  Created by Andy Dent on 6/2/2025.
//

import SwiftUI

@MainActor
protocol UndoRedoStatePublisher: AnyObject {
    func updatedState()
}


@MainActor
final class MenuSceneState: ObservableObject, UndoRedoStatePublisher {
    @Published var updates: Int = 0
    let id = UUID()  // for quick comparisons 
    var canUndo: Bool { sceneDoc.wrappedValue.canUndo }
    var undoMenuItemTitle: String { sceneDoc.wrappedValue.undoMenuItemTitle }
    var canRedo: Bool { sceneDoc.wrappedValue.canRedo }
    var redoMenuItemTitle: String { sceneDoc.wrappedValue.redoMenuItemTitle }
    fileprivate(set) var sceneDoc: Binding<DocundoableDocument>
    
    public static var activeMenuState: MenuSceneState? = nil
    
    init(sceneDoc: Binding<DocundoableDocument>) {
        self.sceneDoc = sceneDoc
        sceneDoc.wrappedValue.publishesStates(to: self)
    }

    func updatedState() {
        updates += 1
    }
    
    func becomeFrontmost() {
        Self.activeMenuState = self
    }
    
    func resignFrontmost() {
        guard Self.activeMenuState?.id == id else { return }
        Self.activeMenuState = nil
    }
}


struct EditMenuCommands: Commands {
#if os(macOS)
    @FocusedObject private var menuState: MenuSceneState?
//@FocusedBinding(\.activeDocument) var document // from ContentView
#else
    var menuState: MenuSceneState? { MenuSceneState.activeMenuState }
#endif
    
    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            Button(action: {
                menuState?.sceneDoc.wrappedValue.undo()
            }) {
                Text(menuState?.undoMenuItemTitle ?? "Undo")
            }
            .keyboardShortcut("Z", modifiers: [.command])
            .disabled(!((menuState?.updates ?? 0) > 0 && menuState?.canUndo ?? false))
            Button(action:  {
                menuState?.sceneDoc.wrappedValue.redo()
            }) {
                Text(menuState?.redoMenuItemTitle ?? "Redo")
            }
            .keyboardShortcut("Z", modifiers: [.command, .shift])
            .disabled(!((menuState?.updates ?? 0) > 0 && menuState?.canRedo ?? false))
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

