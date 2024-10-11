// from https://chatgpt.com/c/66dc8706-3780-8011-a625-bbd1d0f26729
// Andy concerns using many of these with Geometry Reader may cause problems with performance
// so using fixed frame for now


import SwiftUI
//TODO: https://bitbucket.org/touchgram/purrticles/issues/37/cleanup-stepper-control-variants-techdebt

struct StepperNumView<T: Numeric>: View {
    let title: String
    @Binding var value: T
    let step: T
    @FocusState var isFocused: Bool // shared state to ensure cancel numeric keypad
    // WARNING if you copy StepperNumView and use more than one on a view, it won't work:
    // Tapping a +/- on one button will cancel editing text on another. Our real solution is more complex.

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
                    value -= step
                    isFocused = false
                }
                .disabled(zeroBased && value == 0)
                                
                ZStack {
                    // Display the number
                    Text(numFormat.string(for: value) ?? "")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .background(Color.clear)
                        .opacity(isFocused ? 0 : 1)
                        .onTapGesture {
                            isFocused = true
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
                        .opacity(isFocused ? 1 : 0)
                        .onSubmit {
                            isFocused = false
                        }
                        .focused($isFocused) // Automatically focus when editing starts
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                StepperButtonView(isDown: false) {
                    value += step
                    isFocused = false
                }
            }
            .frame(height: 40)
            .background(Color.secondary)
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

        VStack {
            HStack (alignment: .top) {
                StepperNumView<UInt>(title: "Test fives", value: $testFives, step: UInt(5))
            }
            Spacer()
                .frame(height: 40)
            StepperNumView<Double>(title: "Test float", value: $testZero_One, step: 0.1)
        }
        .padding(.horizontal)
    }
}
