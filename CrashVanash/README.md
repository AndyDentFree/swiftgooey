# CrashVanash

Exists to explore fixes to an interesting gotcha I had in my MultiPlatform SwiftUI app [Purrticles][p1] with the combination of:

1. An "Applied" view which only showed controls with non-default values
2. Using a button with [buttonRepeatBehavior][s1]

The combination resulting in, when you hold down the "-" button, as it hits zero and the control vanishes, the app crashes.



[p1]: https://www.touchgram.com/purrticles
[s1]: https://developer.apple.com/documentation/swiftui/view/buttonrepeatbehavior(_:)