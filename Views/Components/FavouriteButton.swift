import SwiftUI

/// Heart toggle bound to the shared ``FavouritesStore``.
///
/// Reused by the list row and the detail screen so favouriting behaves and
/// looks identically wherever it appears.
struct FavouriteButton: View {
    let shop: SakeShop
    var size: CGFloat = 18
    var inactiveColor: Color = .secondary

    @EnvironmentObject private var favourites: FavouritesStore

    private var isFavourite: Bool { favourites.isFavourite(shop) }

    var body: some View {
        Button {
            withAnimation(.snappy) { favourites.toggle(shop) }
        } label: {
            Image(systemName: isFavourite ? AppTheme.Icon.heartFill : AppTheme.Icon.heart)
                .font(.system(size: size))
                .foregroundStyle(isFavourite ? .red : inactiveColor)
                .symbolEffect(.bounce, value: isFavourite)
                .padding(4)
        }
        .buttonStyle(.borderless)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isFavourite)
        .accessibilityLabel(isFavourite ? AppStrings.Favourite.remove : AppStrings.Favourite.add)
    }
}
