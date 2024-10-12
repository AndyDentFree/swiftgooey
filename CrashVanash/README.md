# CrashVanash

Exists to explore fixes to an interesting gotcha I had in my MultiPlatform SwiftUI app [Purrticles][p1] with the combination of:

1. An "Applied" view which only showed controls with non-default values
2. Using a button with [buttonRepeatBehavior][s1]

The combination resulting in, when you hold down the "-" button, as it hits zero and the control vanishes, the app crashes.

**OOPS!** seems on further testing that the crash was because that particular control was bound to a UInt so naturally had an out-of-bounds crash. However, given the interesting buggy behaviour identified below, will keep this sample going.

## Replicating crash in cutdown sample

### Stuck on repeat
This is a very simple example compared to the Purrticles control view which replicates the XCode particle editor (plus additional controls).

The [first commit][g1] exhibits a related but _different bug_ when a simple VStack is used. 

Start holding down the "-" button so the count reduces towards zero.

Instead of a crash, the button vanishes as expected **but** when you press the _Reset Count_ button to make it reappear, the auto-press of the button **is still active** and keeps going until the control disappears again.


[p1]: https://www.touchgram.com/purrticles
[s1]: https://developer.apple.com/documentation/swiftui/view/buttonrepeatbehavior(_:)
[g1]: https://github.com/AndyDentFree/swiftgooey/commit/adead7939877c2e558494ec5dfcc09d3e8fa4b0f