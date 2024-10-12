CrashVanash code change diary entries

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Creation
2024-10-11

Project created using XCode 16 as Multiplatform SwiftUI app with no tests

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Add enough UI to demonstrate bug
2024-10-11

StepperButtonView
StepperNumView
- added

ContentView
- add StepperNumView, text and a reset button


-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Make UI more complex with two buttons and focus control
2024-10-11

ControlFocusTag
- added

StepperNumView
- use a local tag and binding to passed-in ControlFocusTag so two controls can adjust each other's focus

ContentView
- host @FocusState and pass to buttons
- add second button with UInt


-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Identify cause of crash - button with UInt binding that hides on 0 count
2024-10-12

ControlFocusTag
- unsignedCountNonVanish added

ContentView
- countuNonVanishing added
- made button bound to UInt vanish when count hits zero
- added third button also bound to UInt to show contrast if not vanishing
