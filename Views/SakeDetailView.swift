//
//  SakeDetailView.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI

/// Detail screen for a single shop: a hero image with the shop name overlaid,
/// followed by carded sections for the rating/description, address and website.
struct SakeDetailView: View {
    let shop: SakeShop

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Layout.contentSpacing) {
                hero
                summarySection.cardBackground()
                addressSection.cardBackground()
                websiteSection
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(AppStrings.Detail.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavouriteButton(shop: shop, inactiveColor: .primary)
            }
        }
    }

    /// Hero image with a bottom gradient scrim and the shop name overlaid.
    private var hero: some View {
        RemoteImageView(url: shop.pictureURL,
                        height: AppTheme.Layout.detailImageHeight,
                        cornerRadius: AppTheme.Layout.detailImageCornerRadius,
                        loadingTint: .orange)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.55)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
            }
            .overlay(alignment: .bottomLeading) {
                Text(shop.name)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 4)
                    .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Layout.detailImageCornerRadius))
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
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
            .cardBackground()
        }
    }
}
