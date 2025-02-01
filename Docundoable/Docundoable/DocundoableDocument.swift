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

struct DocundoableDocument: FileDocument {
    var count: UInt
    var amount: Double
    var note: String

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
}

// separate helper struct so not complicating Codable synthesis with FileDocument properties
fileprivate struct DocStore: Codable {
    var count: UInt
    var amount: Double
    var note: String
}
