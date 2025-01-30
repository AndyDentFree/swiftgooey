//
//  ContentView.swift
//  Docundoable
//
//  Created by Andrew Dent on 30/1/2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DocundoableDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(DocundoableDocument()))
}
