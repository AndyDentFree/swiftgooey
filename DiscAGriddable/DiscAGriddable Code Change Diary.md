DiscAGriddable code change diary entries

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Creation
2025-02-14

Project created using XCode 16 as Multiplatform SwiftUI app with no tests

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Add enough UI to demonstrate bug
2025-02-14

ContentView
- replaced default content with enough to show problem

DiscAGriddable.xcodeproj
- target dropped to iOS16 so can test on older sims

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Minimise view removing nested DisclosureGroup
2025-02-15

ContentView
- outer DisclosureGroup replaced with HStack
- Rectangle added so can see jump to the side

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
## Minimise view again and add better indication of resize
2025-02-15

ContentView
- outer VStack and its lower content removed so DisclosureGroup is directly inside ScrollView
- Circle added so can see how resizing truncates
