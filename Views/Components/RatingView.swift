//
//  RatingView.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI

/// Displays a 0–5 star rating with the numeric value alongside.
struct RatingView: View {
    let rating: Double

    private let maximumStars = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maximumStars, id: \.self) { index in
                let kind = star(at: index)
                Image(systemName: kind.symbol)
                    .foregroundStyle(kind == .empty ? .gray : .yellow)
                    .font(.caption)
            }

            Text(String(format: "%.1f", rating))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating \(String(format: "%.1f", rating)) out of \(maximumStars)")
    }

    private enum Star {
        case full, half, empty

        var symbol: String {
            switch self {
            case .full: return AppTheme.Icon.starFill
            case .half: return AppTheme.Icon.starHalf
            case .empty: return AppTheme.Icon.star
            }
        }
    }

    /// Resolves the star kind at `index` so a 4.5 rating shows four full stars
    /// and one half star, matching the numeric value shown alongside.
    private func star(at index: Int) -> Star {
        let position = Double(index)
        if rating >= position + 1 { return .full }
        if rating >= position + 0.5 { return .half }
        return .empty
    }
}
