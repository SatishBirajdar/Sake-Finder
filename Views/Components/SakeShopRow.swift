import SwiftUI

/// A single row in the shop lists: thumbnail, name, address, rating and a
/// favourite toggle. Composed entirely from reusable components.
struct SakeShopRow: View {
    let shop: SakeShop

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Layout.rowSpacing) {
            RemoteImageView(url: shop.pictureURL,
                            width: AppTheme.Layout.thumbnailSize,
                            height: AppTheme.Layout.thumbnailSize)

            VStack(alignment: .leading, spacing: AppTheme.Layout.textSpacing) {
                Text(shop.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Label(shop.address, systemImage: AppTheme.Icon.mapPin)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                RatingView(rating: shop.rating)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            FavouriteButton(shop: shop)
        }
        .cardBackground()
    }
}
