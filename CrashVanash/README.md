# CrashVanash

Exists to explore fixes to an interesting gotcha I had in my MultiPlatform SwiftUI app [Purrticles][p1] with the combination of:

1. An "Applied" view which only showed controls with non-default values
2. Using a button with [buttonRepeatBehavior][s1]
3. The crash triggered by a button bound to a UInt 

The combination resulting in, when you hold down the "-" button, as it hits zero and the control vanishes, the app crashes.

**The crash is because the auto-repeat keeps going whilst the button is invisible.**

A near-identical stepper at the bottom of the screen doesn't vanish on count zero - it just stops responding to the '-'button.

Also posted the bug [on StackOverflow][so1]

Note that the branches on this sample show a few different explorations so have been left in the repo.

## Replicating crash in cutdown sample

### Stuck on repeat
This is a very simple example compared to the Purrticles control view which replicates the XCode particle editor (plus additional controls).

The [first commit][g1] exhibits a related but _different bug_ when a simple VStack is used. 

Start holding down the "-" button so the count reduces towards zero.

Instead of a crash, the button vanishes as expected **but** when you press the _Reset Count_ button to make it reappear, the auto-press of the button **is still active** and keeps going until the control disappears again.

## The Fix!
The apple bug is real, filed as FB15477204 and as rdar://FB15477204 **but** in doing all these writeups, had an idea.

This is a _race condition_ bug - the condition to remove it from the view is being evaluated before the `.disabled` clause on the button.

So, what's a good way to delay removal? Add an animation!

The branch [AnimatingFixes][g2] shows this working.

[p1]: https://www.touchgram.com/purrticles
[s1]: https://developer.apple.com/documentation/swiftui/view/buttonrepeatbehavior(_:)
[g1]: https://github.com/AndyDentFree/swiftgooey/commit/adead7939877c2e558494ec5dfcc09d3e8fa4b0f
[g2]: https://github.com/AndyDentFree/swiftgooey/tree/AnimatingFixes
[r]: https://openradar.appspot.com/radar?id=EhAKBVJhZGFyEICAgMbHi-MJ
[so1]: https://stackoverflow.com/questions/79081773/in-swiftui-a-button-continues-to-autorepeat-after-being-hidden-need-to-cancel