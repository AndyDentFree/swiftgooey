//
//  DocundoableDocument.swift
//  Docundoable
//
//  Created by Andy Dent on 30/1/2025.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "test.aussie.docundoable")
    }
}

// stash some mutable state we want to update without triggering struct mutation
fileprivate class DocHelper {
    var undoManager: UndoManager? = nil  // owned by a View and passed in via useUndo(manager)

}

struct DocundoableDocument: FileDocument {
    private var docH = DocHelper()
    var count: UInt {didSet{
        print("didSet count old=\(oldValue) new=\(count)")
        if oldValue != count {
            docH.undoManager?.setActionName("count")
        }
    }}
    var amount: Double  {didSet{
        if oldValue != amount {
            docH.undoManager?.setActionName("amount")
        }
    }}
    var note: String  {didSet{
        if oldValue != note {
            docH.undoManager?.setActionName("note")
        }
    }}
    
    init(count: UInt = 42, amount: Double = 3.14, note: String = "Hello, world!") {
        self.count = count
        self.amount = amount
        self.note = note
    }
    
    static var readableContentTypes: [UTType] { [.exampleText] }
    
    init(configuration: ReadConfiguration) throws {
        let decoder = JSONDecoder()
        guard let json = configuration.file.regularFileContents,
              let docFields = try? decoder.decode(DocStore.self, from: json)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        count = docFields.count
        amount = docFields.amount
        note = docFields.note
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let asJSON = try! encoder.encode(DocStore(count: count, amount: amount, note: note))
        return .init(regularFileWithContents: asJSON)
    }
    
    func setUndoManager(_ um: UndoManager?) {
        docH.undoManager = um
    }
    
    mutating func setDefault(_ tag: ControlFocusTag?) {
        guard let ftag = tag else {return}
        switch ftag {
        case .count:
            count = 0
            
        case .amount:
            amount = 0.0
            
        case .note:
            note = "Hi there you lovely tester"
            
        case .unfocused:
            break
        }
    }
}

// separate helper struct so not complicating Codable synthesis with FileDocument properties
fileprivate struct DocStore: Codable {
    var count: UInt
    var amount: Double
    var note: String
}
