//
//  File.swift
//  Docundoable
//
//  Created by Andrew Dent on 4/2/2025.
//

import Foundation

class Doable {
    var tag: ControlFocusTag
    var name: String { get {"\(tag)"} }
    init(_ tag: ControlFocusTag) {
        self.tag = tag
    }

    func asUInt() -> UInt {0}
    func asDouble() -> Double {0.0}
    func asString() -> String {""}
}

class DoableUInt: Doable {
    var value: UInt
    init(_ tag: ControlFocusTag, _ value: UInt) {
        self.value = value
        super.init(tag)
    }
    override func asUInt() -> UInt { value }
}

class DoableDouble: Doable {
    var value: Double
    init(_ tag: ControlFocusTag, _ value: Double) {
        self.value = value
        super.init(tag)
    }
    override func asDouble() -> Double { value }
}

class DoableString: Doable {
    var value: String
    init(_ tag: ControlFocusTag, _ value: String) {
        self.value = value
        super.init(tag)
    }
    override func asString() -> String { value }
}
