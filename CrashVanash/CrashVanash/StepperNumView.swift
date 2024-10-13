// from https://chatgpt.com/c/66dc8706-3780-8011-a625-bbd1d0f26729
// Andy concerns using many of these with Geometry Reader may cause problems with performance
// so using fixed frame for now


import SwiftUI
//TODO: https://bitbucket.org/touchgram/purrticles/issues/37/cleanup-stepper-control-variants-techdebt

struct StepperNumView<T: Numeric & Comparable>: View {
    let title: String
    let tag: ControlFocusTag
    @Binding var value: T
    let step: T
    @FocusState.Binding var focusedTag: ControlFocusTag?  // shared state to ensure cancel numeric keypad
    
    let zeroBased = T.self == UInt.self
    let numFormat: NumberFormatter =  {
        let ret = NumberFormatter()
        if T.self == Float32.self || T.self == Double.self {
            ret.numberStyle = .decimal
            ret.minimumFractionDigits = 2
            ret.maximumFractionDigits = 2
            ret.minimumIntegerDigits = 1
        } else if T.self == UInt.self {
            ret.minimum = 0
        }
        return ret
    }()
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                StepperButtonView(isDown: true) {
                    if zeroBased {  // may disappear or have other animations
                        withAnimation {
                            if value == 0 {
                                // message will keep appearing in console & if make visible again, keeps repeating until vanishes
                                print("skipping adjustment from repeating button")
                            } else {
                                value = max(0, value-step) // catch when are less than one step away from zero
                            }
                        }
                    } else {
                        value -= step
                    }
                    focusedTag = nil
                }
                .disabled(zeroBased && value == 0)
                
                ZStack {
                    // Display the number
                    Text(numFormat.string(for: value) ?? "")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .background(Color.clear)
                        .opacity(focusedTag == tag ? 0 : 1)
                        .onTapGesture {
                            focusedTag = tag
                        }
                    
                    // Editable TextField
                    TextField("", value: $value, formatter: numFormat)
                    #if os(iOS)
                        .keyboardType(.numberPad)
                    #endif
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.clear)
                        .opacity(focusedTag == tag ? 1 : 0)
                        .onSubmit {
                            focusedTag = nil
                        }
                        .focused($focusedTag, equals: tag) // Automatically focus when editing starts
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                StepperButtonView(isDown: false) {
                    value += step
                    focusedTag = nil
                }
            }
            .frame(height: 40)
            .background(Color.yellow.opacity(0.5))
            .cornerRadius(10)
            
            Text(title)
                .font(.subheadline)
        }
    }
}

struct StepperNumView_Previews: PreviewProvider {
    static var previews: some View {
        @State var testFives: UInt = 5
        @State var testZero_One = 0.7
        @FocusState var parentFlag: ControlFocusTag?
        
        VStack {
            StepperNumView<UInt>(title: "Test fives", tag:.count, value: $testFives, step: UInt(5), focusedTag: $parentFlag)
                .background(Color.purple)
        }
        StepperNumView<Double>(title: "Test float", tag:.unsignedCount, value: $testZero_One, step: 0.1, focusedTag: $parentFlag)
            .background(Color.cyan)
    }
}
