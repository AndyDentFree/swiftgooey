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

fileprivate let nullSceneID: UUID = UUID()


@MainActor
final class MenuSceneState: ObservableObject, UndoRedoStatePublisher {
    var id: UUID  // for quick comparisons, also because in iPadOS the global instance is copied from local as become frontmost
    fileprivate(set) var sceneDoc: Binding<DocundoableDocument>  // reassigned in static instance (on iPad) as scenes becomeFrontmost
    @Published var updates: Int = 0  // no dependency on this needed, just having one published var means macOS menus pull the reset
    // simple getter work because menus PULL from the focusedObject
    var canUndo: Bool { sceneDoc.wrappedValue.canUndo }
    var undoMenuItemTitle: String { sceneDoc.wrappedValue.undoMenuItemTitle }
    var canRedo: Bool { sceneDoc.wrappedValue.canRedo }
    var redoMenuItemTitle: String { sceneDoc.wrappedValue.redoMenuItemTitle }
#if !os(macOS)
    private static var cachedNullSceneDoc: Binding<DocundoableDocument> = .constant(DocundoableDocument()) // static instance needed so can init static object early

    // static always instantiated for iPad menu bindings but typed as optional because macOS uses FocusedObject
    // effectively PUBLISHES specific scene's sceneDoc by having copy of the binding
    public static var publishingMenuState: MenuSceneState? = MenuSceneState(sceneDoc: cachedNullSceneDoc, id: nullSceneID)
#endif
    
    init(sceneDoc: Binding<DocundoableDocument>, id: UUID = UUID()) {
        self.id = id
        self.sceneDoc = sceneDoc
        sceneDoc.wrappedValue.publishesStates(to: self)
    }
    
#if os(macOS)
    func updatedState() {
        updates += 1 // minimal update to cause menus to refresh on macOS because @FocusedObject correctly binds them to the instance
    }
    
#else
    func updatedState() {
        guard let ams = Self.publishingMenuState else {
            return
        }
        if ams.id != id {
            print("Somehow updatedState called but we're not frontmost scene, this is a bug")
            becomeFrontmost()
        }
        ams.updates += 1  // instead of relying on rebinding via FocusedObject, poke the one which is the bound global instance
    }
    
    func becomeFrontmost() {
        guard let ams = Self.publishingMenuState else {
            return
        }
        ams.sceneDoc = sceneDoc
        ams.id = id
        ams.updates += 1 // kick it to update the menus
    }
    
    func resignFrontmost() {
        guard let ams = Self.publishingMenuState, ams.id == id else { return }
        ams.id = nullSceneID  // so comparisons fail if call resignFrontmost twice in a row
        ams.sceneDoc = Self.cachedNullSceneDoc
    }
#endif
}


struct EditMenuCommands: Commands {
#if os(macOS)
    @FocusedObject private var menuState: MenuSceneState?
#else
    var menuState: MenuSceneState? =  MenuSceneState.publishingMenuState
    // concrete watched object triggering updates even though nothing is bound to it
    // relies on platform-specific init of the static to an existing object even though typed as null
    @ObservedObject var watchedMenuState: MenuSceneState =  MenuSceneState.publishingMenuState!
#endif
    
    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            Button(action: {
                menuState?.sceneDoc.wrappedValue.undo()
            }) {
                Text(menuState?.undoMenuItemTitle ?? "Undo")
            }
            .keyboardShortcut("Z", modifiers: [.command])
            .disabled(!(menuState?.canUndo ?? false))
            Button(action:  {
                menuState?.sceneDoc.wrappedValue.redo()
            }) {
                Text(menuState?.redoMenuItemTitle ?? "Redo")
            }
            .keyboardShortcut("Z", modifiers: [.command, .shift])
            .disabled(!(menuState?.canRedo ?? false))
        }
    }
}
