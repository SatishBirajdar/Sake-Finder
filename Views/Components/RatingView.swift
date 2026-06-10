import SwiftUI

/// Displays a 0–5 star rating with the numeric value alongside.
struct RatingView: View {
    let rating: Double

    private let maximumStars = 5

    private var filledStars: Int { Int(rating.rounded()) }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maximumStars, id: \.self) { index in
                let isFilled = index < filledStars
                Image(systemName: isFilled ? AppTheme.Icon.starFill : AppTheme.Icon.star)
                    .foregroundStyle(isFilled ? .yellow : .gray)
                    .font(.caption)
            }

            Text(String(format: "%.1f", rating))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating \(String(format: "%.1f", rating)) out of \(maximumStars)")
    }
}
