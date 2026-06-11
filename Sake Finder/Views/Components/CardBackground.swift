//
//  CardBackground.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI

/// Wraps content in the app's standard rounded "card" surface.
///
/// Centralising the card look here keeps the list rows and the detail sections
/// visually consistent and avoids repeating the padding/shadow/shape values.
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.Layout.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Layout.cardCornerRadius)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            )
    }
}

extension View {
    /// Applies the app's standard card styling (padding, rounded shape, shadow).
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
