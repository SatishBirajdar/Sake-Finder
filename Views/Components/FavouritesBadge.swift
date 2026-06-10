import SwiftUI

/// Navigation-bar indicator showing how many shops are favourited.
struct FavouritesBadge: View {
    let count: Int

    private var hasFavourites: Bool { count > 0 }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: hasFavourites ? AppTheme.Icon.heartFill : AppTheme.Icon.heart)
                .foregroundStyle(hasFavourites ? .red : .secondary)
            if hasFavourites {
                Text("\(count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.red)
            }
        }
        .fixedSize()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(count) favourites")
    }
}
