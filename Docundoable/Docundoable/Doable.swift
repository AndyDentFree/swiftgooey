//
//  File.swift
//  Docundoable
//
//  Created by Andrew Dent on 4/2/2025.
//

import Foundation

protocol Doable {
    associatedtype valueType
    var tag: ControlFocusTag { get }
    var value: valueType { get }
    var name: String { get }

    func asUInt() -> UInt
    func asDouble() -> Double
    func asString() -> String
}

struct DoableUInt: Doable {
    typealias valueType = UInt
    var tag: ControlFocusTag
    var value: UInt
    init(_ tag: ControlFocusTag, _ value: UInt) {
        self.tag = tag
        self.value = value
    }
    func asUInt() -> UInt { value }
}

struct DoableDouble: Doable {
    typealias valueType = Double
    var tag: ControlFocusTag
    var value: Double
    init(_ tag: ControlFocusTag, _ value: Double) {
        self.tag = tag
        self.value = value
    }
    func asDouble() -> Double { value }
}

struct DoableString: Doable {
    typealias valueType = String
    var tag: ControlFocusTag
    var value: String
    init(_ tag: ControlFocusTag, _ value: String) {
        self.tag = tag
        self.value = value
    }
    func asString() -> String { value }
}

// default implementations
extension Doable {
    func asUInt() -> UInt { 0 }
    func asDouble() -> Double { 0.0 }
    func asString() -> String { "" }
    var name: String { get { "\(tag)"} }
}
