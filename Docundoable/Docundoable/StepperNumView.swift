//
//  StepperButtonView.swift
//  Purrticles
//
//  Created by Andy Dent on 17/9/2024.
//

import SwiftUI

fileprivate enum EditPhase: Equatable {
    case idle
    case editing
    case committing   // suppress focus-change recursion while we finalize
}

struct StepperNumView<T: Numeric & Comparable & StepperNumberFormatting>: View {
    let title: String
    let tag: ControlFocusTag
    @Binding var value: T
    let step: T
    @FocusState.Binding var focusedTag: ControlFocusTag?  // shared state to ensure cancel numeric keypad
    
    let zeroBased = T.self == UInt.self
    let isFloat =  T.self == Float32.self || T.self == Double.self
    let numFormat: NumberFormatter = { T.stepperFormatter }()
    
    //MARK:- Support buffered editing so not reacting to each character by reformatting
    @State private var draftText: String = ""
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
        VStack {
            ZStack {
                HStack(spacing: 0) {
                    StepperButtonView(isDown: true) {
                        if zeroBased {  // may disappear or have other animations
                            if value == 0 {
                                // message will keep appearing in console & if make visible again, keeps repeating until vanishes
                                print("hit zero - skipping decrement from repeating button")
                            } else {
                                value = max(0, value-step) // catch when are less than one step away from zero
                            }
                        } else {
                            value -= step
                        }
                        focusedTag = nil
                    }
                    .disabled(zeroBased && value == 0)
                    
                    // Display the number
                    Text(numFormat.string(for: value) ?? "")
                        .font(.callout)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.primary)
                        .background(Color.clear)
                        .onTapGesture {
                            focusedTag = tag // triggers onChangeOf and thus setup for edit
                        }
                    
                    StepperButtonView(isDown: false) {
                        value += step
                        focusedTag = nil
                    }
                }
                .opacity(focusedTag == tag ? 0 : 1)
                // Editable TextField
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
            }  // ZStack for TextEntry overlay
            .frame(height: 40)
            .background(Color.secondarySystemBackground)
            .cornerRadius(10)
            
            Text(title)
                .font(.subheadline)
        }
    }
}

// Colored backgrounds to see total control size
struct StepperNumView_Previews: PreviewProvider {
    static var previews: some View {
        @State var testFives: UInt = 5
        @State var testZero_One = 0.7
        @FocusState var parentFlag: ControlFocusTag?
        
        VStack {
            Spacer()
            StepperNumView<UInt>(title: "Test fives", tag:.count, value: $testFives, step: UInt(5), focusedTag: $parentFlag)
                .background(Color.purple.opacity(0.5))
            Spacer()
                .frame(height: 40)
            StepperNumView<Double>(title: "Test float", tag:.amount, value: $testZero_One, step: 0.1, focusedTag: $parentFlag)
                .background(Color.cyan.opacity(0.5))
            Spacer()
        }
        .frame(width: 80)
    }
}
