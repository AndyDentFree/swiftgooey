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
    var undoStack = [Doable]()
    var redoStack = [Doable]()
    var isUndoing = false
    func append(_ doable: Doable) {
        if isUndoing {
            redoStack.append(doable)
        } else {
            undoStack.append(doable)
        }
    }
}

fileprivate let defaultUndoTitle = "Undo"
fileprivate let defaultRedoTitle = "Redo"


struct DocundoableDocument: FileDocument {
    private var docH = DocHelper()
    
    var count: UInt {didSet{
        print("didSet count old=\(oldValue) new=\(count)")
        if oldValue != count {
            docH.append(DoableUInt(.count, oldValue))
        }
    }}
    var amount: Double  {didSet{
        if oldValue != amount {
            docH.append(DoableDouble(.amount, oldValue))
        }
    }}
    var note: String  {didSet{
        if oldValue != note {
            docH.append(DoableString(.note, oldValue))
        }
    }}
    var undoMenuItemTitle: String {get{
        guard let doable = docH.undoStack.last else {return defaultUndoTitle}
        return "Undo \(doable.name)"
    }}
    var redoMenuItemTitle: String  {get{
        guard let doable = docH.redoStack.last else {return defaultRedoTitle}
        return "Redo \(doable.name)"
    }}
    var canUndo: Bool {get{ !docH.undoStack.isEmpty }}
    var canRedo: Bool {get{ !docH.redoStack.isEmpty }}

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
    
    mutating func undo() {
        docH.isUndoing = true
        apply(doableStack: &docH.undoStack)
        docH.isUndoing = false
    }
    
    mutating func redo() {
        assert(!docH.isUndoing, "undo() should be atomic and set isUndoing=false prior exit")
        apply(doableStack: &docH.redoStack)
    }
    
    private mutating func apply(doableStack: inout [Doable]) {
        guard let doable = doableStack.popLast() else {return}
        switch doable.tag {
        case .count:
            count = doable.asUInt()
        case .amount:
            amount = doable.asDouble()
        case .note:
            note = doable.asString()
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
