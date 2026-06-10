import SwiftUI

/// Detail screen for a single shop: hero image, rating, description, address
/// and website link, plus a favourite toggle in the navigation bar.
struct SakeDetailView: View {
    let shop: SakeShop

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Layout.contentSpacing) {
                RemoteImageView(url: shop.pictureURL,
                                height: AppTheme.Layout.detailImageHeight,
                                cornerRadius: AppTheme.Layout.detailImageCornerRadius)
                    .frame(maxWidth: .infinity)

                summarySection
                addressSection
                websiteSection
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(AppStrings.Detail.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavouriteButton(shop: shop, inactiveColor: .primary)
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(shop.name)
                .font(.title2.weight(.semibold))

            RatingView(rating: shop.rating)

            Text(shop.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(AppStrings.Detail.addressSection, systemImage: AppTheme.Icon.mapPin)
                .font(.subheadline.weight(.semibold))

            if let mapsURL = shop.mapsURL {
                Link(destination: mapsURL) {
                    Label(shop.address, systemImage: AppTheme.Icon.location)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            } else {
                Text(shop.address)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var websiteSection: some View {
        if let websiteURL = shop.websiteURL {
            VStack(alignment: .leading, spacing: 8) {
                Label(AppStrings.Detail.visitSection, systemImage: AppTheme.Icon.globe)
                    .font(.subheadline.weight(.semibold))

                Link(destination: websiteURL) {
                    Label(AppStrings.Detail.openWebsite, systemImage: AppTheme.Icon.openLink)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}
