# DiscAGriddable

Exists to explore fixes to an interesting gotcha I had in my MultiPlatform SwiftUI app [Purrticles][p1] export view, with some nested [DisclosureGroup][a1] problems. Also asked on [StackOverflow][so1].

## The Problem
With a [Grid][a2] inside the `DisclosureGroup`, toggling the group open causes a minor width expansion. Depending on the model of phone, this results in the disclosure chevrons being unpleasantly close to the trailing side, or vanishing completely off screen!

The minimal amount of layout with the `Grid` shows the problem is inherently one about putting it inside a `DisclosureGroup` as seen in the recording and screenshots below. Note how when Formatting is tapped, the outer chevron jumps sideways. The collapsed width is the desired layout and when the Grid is exposed, it pushes things wider.

![Two partial screenshots aligned vertically, with a pink line showing how controls moved sideways when the Formatting group expanded](TwistingBug.png "Two screenshots with alignment to show expansion")

![Gif showing the width changing when Formatting tapped](TwistingBug.gif "Recording of tapping ")

## Explorations

### ScrollView is a factor
Cutting down arbitrarily commenting out lines - if the outer `ScrollView` is removed, the problem vanishes. This is not viable in the original code as there's too tall a set of controls.

### Outer Disclosure and VStack not factors
The hierarchy is 
- `ScrollView`
  - `VStack`  // A
    - `DisclosureGroup`  // B
      - `DisclosureGroup`
        - `Grid`

Simplifying things by commenting out the outer A and B doesn't fix, but it's harder to see.

Later version took out the outer disclosure and used an `HStack` to show expansion with a couple of shapes alongside:

![Two partial screenshots aligned vertically showing circle truncated by expansion resizing](SimplestTwistDemo.png "Simpler view showing resize still happens")


## Grudge held
This little bit of nasty UI rendering caught me when I thought I'd utterly finished with _stupid SwiftUI bugs_ after the long wrestling with Undo (see [Docundoable](../Docundoable/README.md) for that saga)

So this is grumpily-written code hence the project name.

[p1]: https://www.touchgram.com/purrticles
[a1]: https://developer.apple.com/documentation/swiftui/disclosuregroup
[a2]: https://developer.apple.com/documentation/swiftui/grid
[so1]: https://stackoverflow.com/questions/79441312/a-grid-inside-a-disclosuregroup-inside-a-scrollview-causes-unwanted-expansion