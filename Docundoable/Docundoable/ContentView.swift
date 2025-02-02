//
//  ContentView.swift
//  Docundoable
//
//  Created by Andy Dent on 30/1/2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DocundoableDocument
    @FocusState var focTag: ControlFocusTag?  // used to hide keypad, set by StepperNumView & TextEditor
    @Environment(\.undoManager) var undoManager

    var body: some View {
        VStack {
            Spacer()
            Text("Testbed for controls and undo/redo")
                .font(.headline)
            Text("especially when edit numbers using keyboard")
                .font(.subheadline)
            Spacer()
            HStack {
                Spacer()
                StepperNumView<UInt>(title: "Count", tag: .count, value: $document.count, step: 1, focusedTag: $focTag)
                Spacer()
                StepperNumView<Double>(title: "Amount", tag: .amount, value: $document.amount, step: 1, focusedTag: $focTag)
                Spacer()

            }
            Spacer()
            TextEditor(text: $document.note)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            .focused($focTag, equals: .note)
        }
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { undoManager?.undo() }) {
                        Label(undoManager?.undoMenuItemTitle ?? "",
                                systemImage: "arrow.uturn.backward")
                    }
                    .disabled(!(undoManager?.canUndo ?? false))
                    Button(action:  { undoManager?.redo() }) {
                        Label(undoManager?.redoMenuItemTitle ?? "",
                              systemImage: "arrow.uturn.forward")
                    }
                    .disabled(!(undoManager?.canRedo ?? false))
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
#endif
        }
        .onAppear {
            document.setUndoManager(undoManager)
        }
        .onChange(of: undoManager) {_ in
            document.setUndoManager(undoManager)
            // ignoring deprecation warning for now because really annoying to have conditional available
        }
    }
}


#if DEBUG
struct StandardParticleControls_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView(document: .constant(DocundoableDocument()))
    }
}
#endif
