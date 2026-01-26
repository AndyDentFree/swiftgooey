//
//  FocusedNumView.swift
//  Docundoable
//
//  Created by Andrew Dent on 26/1/2026.
//


import SwiftUI

fileprivate enum EditPhase: Equatable {
    case idle
    case editing
    case committing   // suppress focus-change recursion while we finalize
}

// reusable TextView for numeric editing in StepperNumView and similar
struct FocusedNumView<T: Numeric & Comparable & StepperNumberFormatting>: View {
    let tag: ControlFocusTag
    @Binding var value: T
    @FocusState.Binding var focusedTag: ControlFocusTag?  // shared state to ensure cancel numeric keypad
    
    let zeroBased = T.self == UInt.self
    let isFloat =  T.self == Float32.self || T.self == Double.self
    let numFormat: NumberFormatter
    
    //MARK:- Support buffered editing so not reacting to each character by reformatting
    @State private var draftText = "" //: String = { numFormat.string(for: value) ?? ""}()
    @State private var phase = EditPhase.idle

    private var formattedValueString: String {
        numFormat.string(for: value) ?? ""
    }


    private func commitEditing() {
        guard phase == .editing else { return }

        phase = .committing
        defer {
            phase = .idle
            if focusedTag == tag {
                focusedTag = nil // may be doing commit because changed to somewhere else
            }
        }

        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            value = T.zero
        } else {
            guard let number = numFormat.number(from: trimmed) else {
                draftText = formattedValueString // Parse failed: revert
                return
            }
            value.assignFromNSNumber(number)
        }
        // Normalize draft to canonical formatted display after commit
        draftText = formattedValueString
    }


    //MARK:- View

    var body: some View {
        TextField("", text: $draftText)
#if os(iOS)
            .keyboardType(isFloat ? .decimalPad : .numberPad)
#endif
            .multilineTextAlignment(.center)
            .font(.callout)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .background(Color.clear)
            .opacity(focusedTag == tag ? 1 : 0)
            .onSubmit {
                commitEditing()
            }
            .onChangeOf(focusedTag) { newFocus in
                // Suppress re-entrancy caused by our own focus updates
                guard phase != .committing else { return }

                if newFocus == tag {
                    // If focus arrived externally (e.g. programmatically), ensure we’re in editing mode.
                    if phase == .idle {
                        draftText = formattedValueString
                        phase = .editing
                    }
                    else {
#if DEBUG
                        print("impossible transition changing tag to \(tag) but phase is \(phase) ")
#endif
                    }
                } else {
                    // Leaving focus: commit if we were editing.
                    if phase == .editing {
                        commitEditing()
                    }
                }
            }
            .focused($focusedTag, equals: tag) // Automatically focus when editing starts
    }
}
