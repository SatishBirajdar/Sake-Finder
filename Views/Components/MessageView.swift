//
//  MessageView.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI

/// Full-screen centred message used for empty and error states.
///
/// Reused for both the "no favourites" empty state and the load-failure state
/// (with an optional retry action), keeping those screens visually consistent.
struct MessageView: View {
    let systemImage: String
    let title: String
    var message: String?
    var tint: Color = .secondary
    var actionTitle: String?
    var action: (() -> Void)?
    /// Accessibility identifier applied to the action button (for UI tests).
    var actionIdentifier: String?

    var body: some View {
        VStack(spacing: AppTheme.Layout.messageSpacing) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(tint)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier(actionIdentifier ?? "")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
