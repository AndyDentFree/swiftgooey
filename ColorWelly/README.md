# ColorWelly
Sample to explore a [bug][p2] affecting the [Purrticles][p1] interface on iPad **only** using iPadOS versions 16.x and 17.x.

The two `ColorPicker` controls are almost impossible to tap - most of the time they fail to react and don't show the popover control.

Also noted in this sample, **the same bug affects** `TextField` **controls** - the keyboard starts to appear then meekly dives off screen and the field doesn't edit.


## State of re-creating the Purrticles bug
I'm easing up to a very complex nested screen like you can see here:

![<# alt text #>](img/iPadLandscapeExportNotShowing.png "iPadLandscapeExportNotShowing.png")

That screen comprises:
- overall picker vs "document view"
- three-panels with leftmost often hidden (exported code)
- a big hosted SpriteKit `SKView`
- controls on the right inside a tabbed view
- the controls and backgrounds have many tap gesture recognisers so can detect focus changes and dismiss a keyboard from going into edit mode when you press a number label

### Attempts
- simple with three rows fails to replicate the bug. All pickers work.
- putting a single big view to left of Grid still works
- using our custom view for label to left of ColorPicker 
- adding overall Group and GeometryReader around entire View, so can split up space proportionally
- adding "tabs" as segmented picker control above scrolling controls
- add enough rows to the scrollview that it would require scrolling to show all 
- **found it** adding an onTapGesture on the outside Grid causes the problem
- simplified back to earlier 3 rows, without view alongside, GeometryReader or tabs - still replicable and with a TextEdit can see how focus is not changed by ColorPicker
- Setup even simpler demo with 2 rows of colorpicker plus a TextEdit row but with tabs to choose different gesture scenarios
    - trying a SimultaneousGesture in final scenario still broken on iPadOS 16 & 17
    - it further breaks the ability to tap in the TextField and see the keyboard, immediately dismissing focus
- putting the `.onTapGesture` on each individual `GridRow` has the same bug as putting it on the overall `Grid` so that's not a solution
- Using a ZStack to put a Color section with tapGesture behind is a lot more work but is **a robust fix for all OS**

### Demonstrating focus change
Adding a TextField to one of the rows will display the inbuilt keyboard. Changing focus will dismiss the keyboard.

This proves that the whole of grid tap gesture, which is now disabled for iOS16 & 17, indeed clears focus. The new code for the tap gesture includes a console print so we can see it being triggered.

### Second Problem - ColorPicker fails to set focus
Noted with the addition of a text field is that despite `focused($focTag, equals: 1)` tapping the picker doesn't change focus and so doesn't cancel the keyboard.

This was not resolved at any point, is probably _desired behaviour_.

[p1]: https://www.touchgram.com/purrticles
[p2]: https://www.reddit.com/r/SwiftUI/comments/1hl4htd/ipad_colorpicker_bug_not_responding_to_taps_on/
