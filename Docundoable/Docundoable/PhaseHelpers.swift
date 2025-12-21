//
//  PhaseHelpers.swift
//  Docundoable
//
//  Created by Andy Dent on 4/12/2025.
//

#if os(iOS)
import SwiftUI


/// Callbacks when this window becomes / stops being frontmost.
/// Workarounds for bugs in iPadOS 26.x
struct FrontmostWindowObserver: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase

    let onBecomeFrontmost: () -> Void
    let onResignFrontmost: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .modifier(FrontmostWindowObserver_iOS18(
                    onBecomeFrontmost: onBecomeFrontmost,
                    onResignFrontmost: onResignFrontmost
                ))
        } else {
            content
                .onChange(of: scenePhase) { oldValue, newValue in
                    if newValue == .active {
                        onBecomeFrontmost()
                    } else if oldValue == .active {
                        onResignFrontmost()
                    }
                }
                .task {
                    if scenePhase == .active {
                        onBecomeFrontmost()
                    }
                }
        }
    }
}

@available(iOS 18.0, *)
private struct FrontmostWindowObserver_iOS18: ViewModifier {
    @Environment(\.appearsActive) private var appearsActive

    let onBecomeFrontmost: () -> Void
    let onResignFrontmost: () -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: appearsActive) { _, newValue in
                if newValue {
                    onBecomeFrontmost()
                } else {
                    onResignFrontmost()
                }
            }
            .task {
                if appearsActive {
                    onBecomeFrontmost()
                }
            }
    }
}

extension View {
    func onFrontmostWindowChange(
        onBecomeFrontmost: @escaping () -> Void,
        onResignFrontmost: @escaping () -> Void
    ) -> some View {
        modifier(FrontmostWindowObserver(
            onBecomeFrontmost: onBecomeFrontmost,
            onResignFrontmost: onResignFrontmost
        ))
    }
}
#endif
