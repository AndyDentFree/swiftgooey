# CrashVanash

Exists to explore fixes to an interesting gotcha I had in my MultiPlatform SwiftUI app [Purrticles][p1] with the combination of:

1. An "Applied" view which only showed controls with non-default values
2. Using a button with [buttonRepeatBehavior][s1]

The combination resulting in, when you hold down the "-" button, as it hits zero and the control vanishes, the app crashes.

## Replicating crash in cutdown sample
This is a very simple example compared to the Purrticles control view which replicates the XCode particle editor (plus additional controls).

The first commit exhibits a related but _different bug_ when a simple VStack is used. 

Start holding down the "-" button so the count reduces towards zero.

Instead of a crash, the button vanishes as expected **but** when you press the _Reset Count_ button to make it reappear, the auto-press of the button **is still active** and keeps going until the control disappears again.

With ContentView containing
```
        VStack {
            Text("CrashVanash!")
                .font(.largeTitle)
            Spacer()
            Button("Reset Count") {
                count = 10
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Text("Button vanishes when hits zero, holding down on\n+/- to repeat should trigger the crash")
            Spacer()
                .frame(height: 20)
            if count > 0 {
                StepperNumView<Int>(title: "Count, tap centre to edit", value: $count, step: 1)
                    .padding(.horizontal)
            } else {
                Text("Button vanished with invalid count")
            }
            Spacer()
        }
```



[p1]: https://www.touchgram.com/purrticles
[s1]: https://developer.apple.com/documentation/swiftui/view/buttonrepeatbehavior(_:)