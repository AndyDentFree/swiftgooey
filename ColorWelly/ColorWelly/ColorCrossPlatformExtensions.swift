//
//  ColorCrossPlatformExtensions.swift
//  ColorWelly
//
//  Created by Andy Dent on 2/1/2025.
//

import SwiftUI

extension Color {
    static var systemBackground: Color {
#if os(iOS)
        return Color(uiColor: .systemBackground)
#elseif os(macOS)
        return Color(nsColor: .windowBackgroundColor)
#else
        return Color.white // Fallback color, can be customized
#endif
    }
}
