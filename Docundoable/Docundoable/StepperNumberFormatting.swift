//
//  StepperNumberFormatting.swift
//  Docundoable
//
//  Created by Andrew Dent on 26/1/2026.
//

import SwiftUI

protocol StepperNumberFormatting {
    static var stepperFormatter: NumberFormatter { get }
    mutating func assignFromNSNumber(_ number: NSNumber)
}

extension StepperNumberFormatting {
    // Sensible default for integer-ish types
    static var stepperFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }
}

// Floats: always 2 fraction digits
extension Double: StepperNumberFormatting {
    static var stepperFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.minimumIntegerDigits = 1
        return f
    }
    
    mutating func assignFromNSNumber(_ number: NSNumber) {
        self = number.doubleValue
    }
}

extension Float: StepperNumberFormatting {
    static var stepperFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.minimumIntegerDigits = 1
        return f
    }
    
    mutating func assignFromNSNumber(_ number: NSNumber) {
        self = number.floatValue
    }
}


extension Int: StepperNumberFormatting {
    static var stepperFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.minimumIntegerDigits = 1
        return f
    }
    
    mutating func assignFromNSNumber(_ number: NSNumber) {
        self = Int(number.int64Value)
    }
}

// UInt: enforce zero minimum
extension UInt: StepperNumberFormatting {
    static var stepperFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimum = 0
        return f
    }
    
    mutating func assignFromNSNumber(_ number: NSNumber) {
        let i = number.int64Value
        let clamped = i <= 0 ? 0 : i
        self = UInt(clamped)
    }
}
