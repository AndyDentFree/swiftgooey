//
//  TinyDoc.swift
//  CrashVanash
//
//  Created by Andrew Dent on 12/10/2024.
//

import SwiftUI

// helper function to fake a "lengthy" operation such as adjusting a SKEmitter
fileprivate func blockMainThread(for seconds: Double) {
    print("Blocking main thread for \(seconds) seconds")
    let until = Date().addingTimeInterval(seconds)
    while Date() < until {
        // Keep the run loop active to allow system events to be processed
        RunLoop.current.run(mode: .default, before: until)
    }
}

struct TinyDoc: Sendable {
    var count = 40 { didSet {
        blockMainThread(for: blockSecs)
    }}
   var ucount: UInt = 12 { didSet {
       blockMainThread(for: blockSecs)
   }}
    var blockSecs: Double = 0.01
    
    mutating func reset() {
        count = 40
        ucount = 12
    }
}
