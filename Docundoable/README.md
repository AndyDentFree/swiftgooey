# DocUndoable - Documents and Undo with SwiftUI
Sample to explore nuances of Document-based apps, specifically using the struct approach of [FileDocument][a1] with the [UndoManager][a2].

Got sufficiently frustrated during the development of [Purrticles][p1] with its complex editing environment that wanted both to explore the alternatives and have a sample I coud share to accompany articles/rants about the issues.

[Purrticles][p1] 

## Nested views vs Undo

### Combination control with an ephemeral TextField
The main [Purrticles][p1] control views mimic XCode's Particle Emitter editor with a panel of controls that have a stepper combined with tappable, editable label.

As is common SwiftUI practice, I use a separate View to provide these.

StepperNumView has a label which, when tapped, shows a TextField the width of the control.

Using UndoManager, an undo can be triggered:

1. after tapping the decrement or increment buttons
2. whilst editing the text field, after each character typed.

**But** when focus is lost from the control, it seems to reset the UndoManager state, so `canUndo` becomes false.

## Common Gotchas

### Wanting UndoMager in a doc
As per this [StackOverflow question][so1] it is common to have data handling code in your _Document_ class or struct, that may want to call [UndoManager][a2] functions.

The safe way to pass this is to be aware of the UndoManager only being valid in context of a SwiftUI View and that it can change during the lifetime of the view, especially being nil at initial appearance. This was picked up in a good [Hacking with Swift forum post][hws1].

So, to cope with all scenarios:

```
struct DocumentView: View {
    let document : MyDocument
    @Environment(\.undoManager) var undoManager  // get from environment, don't pass from above
    
    var body: some View {
        MyDocumentEditor(document: document)
        .onAppear {
            document.setUndoManager(undoManager: undoManager)
        }
        .onChange(of: undoManager) { newManager in
            document.setUndoManager(undoManager: newManager)
        }
    }
}
```

### Testing undo availability
We want Undo/Redo buttons to be enabled when such info is available.

The obvious way is to use the UndoManager:

```
struct MainDocWindow: View {
    @Environment(\.undoManager) var undoManager
    var body: some View {
...    
		.toolbar {
			#if os(iOS)
			ToolbarItem(placement: .navigationBarTrailing) {
				Menu {
					Button(action: undo) {
						Label(undoManager?.undoMenuItemTitle ?? "", systemImage: "arrow.uturn.backward")
					}
					.disabled(!(undoManager?.canUndo ?? false))
					Button(action: redo) {
						Label(undoManager?.redoMenuItemTitle ?? "", systemImage: "arrow.uturn.forward")
					}
					.disabled(!(undoManager?.canRedo ?? false))
				} label: {
					Image(systemName: "arrow.uturn.backward.circle")
				}
				.menuStyle(BorderlessButtonMenuStyle())
			}
```

However, as noted in [this SO answer][so2]

> UndoManager.canUndo is not KVO compliant

Which means that you can't rely on the values of `canUndo` etc. being updated to cause SwiftUI view changes to enable the menu items.

Even worse, if you have a change event or callback from your own `undo` command that queries `canRedo` it will cause termination of some UndoManager states:

> canRedo fires the checkpoint notification: "Posted whenever an NSUndoManager object opens or closes an undo group (except when it opens a top-level group) and when checking the redo stack in canRedo." 

I ended up completely ignoring `canUndo` and the `undoMenuTitle` and implementing my own.



[p1]: https://www.touchgram.com/purrticles

[a1]: https://developer.apple.com/documentation/swiftui/filedocument
[a2]: https://developer.apple.com/documentation/foundation/undomanager

[so1]: https://stackoverflow.com/questions/63919607/capturing-undomanager-from-swiftui-environment
[so2]: https://stackoverflow.com/questions/60647857/undomanagers-canundo-property-not-updating-in-swiftui

[hws1]: https://www.hackingwithswift.com/forums/macos/undomanager-tinydraw-hws-and-view-onappear/11359