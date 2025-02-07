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
#if os(iOS)
            .toolbar {  // one toolbar on any of the views adds these buttons to all keyboard that pop up even on views like Note's TextEditor further down
                if focTag != nil {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Default") {
                            document.setDefault(focTag)
                            focTag = nil
                        }
                        Spacer()
                        Button("Done") {
                            focTag = nil
                        }
                    }
                }
            }
#endif
            Spacer()
            Spacer()
            VStack{
                TextEditor(text: $document.note)
                    .background(
                        Rectangle()
                            .fill(Color.pink)
                            .contentShape(Rectangle()) // Reinforces tappable area
                    )
                    .padding(8)
                    .focused($focTag, equals: .note)
            }
            .background(Color.secondarySystemBackground)
            .padding([.leading, .trailing, .bottom], 8)
            .contentShape(Rectangle()) // Ensures the whole cell is tappable
            .onTapGesture {
                focTag = nil
            }
        }  // top vstack
        .background(
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle()) // Reinforces tappable area
        )
        .focusedSceneValue(\.activeDocument, $document) // inject the current document for commands
        .onTapGesture {
            focTag  = nil
        }
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { document.undo() }) {
                        Label(document.undoMenuItemTitle,
                              systemImage: "arrow.uturn.backward")
                    }
                    .disabled(!(document.canUndo))
                    Button(action:  { document.redo() }) {
                        Label(document.redoMenuItemTitle,
                              systemImage: "arrow.uturn.forward")
                    }
                    .disabled(!(document.canRedo))
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
#endif
        }
        .onAppear {
            #if os(macOS)
            // DispatchQueue.main.async so view hierarchy is ready.
            DispatchQueue.main.async {
                self.focTag = .note  // default is that one of the steppers has focus which is a bit weird
            }
            #endif
        }

    }  // body
}


#if DEBUG
struct StandardParticleControls_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView(document: .constant(DocundoableDocument()))
    }
}
#endif
