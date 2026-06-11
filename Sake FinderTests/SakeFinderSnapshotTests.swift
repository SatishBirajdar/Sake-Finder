//
//  SakeFinderSnapshotTests.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Sake_Finder

/// Snapshot tests for the reusable UI components.
///
/// On the first run (when no reference image exists) each assertion records the
/// reference into a `__Snapshots__` folder next to this file and fails; commit
/// those references and subsequent runs compare against them.
///
/// - Important: Record/compare on a consistent simulator (these were authored
///   against iPhone 15, iOS 17) — fonts and scale differ across devices.
@MainActor
final class SnapshotTests: XCTestCase {

    // MARK: - Fixtures

    private func makeShop(name: String = "Masumi Brewery",
                          rating: Double = 4.5) -> SakeShop {
        SakeShop(
            name: name,
            description: "A historic Nagano sake brewery.",
            picture: nil, // nil → deterministic placeholder, no network in tests
            rating: rating,
            address: "123 Sake Street, Nagano",
            coordinates: [0, 0],
            googleMapsLink: "https://maps.apple.com",
            website: "https://example.com"
        )
    }

    private func makeFavourites() -> FavouritesStore {
        let suiteName = "snapshot.favourites.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        addTeardownBlock { defaults.removePersistentDomain(forName: suiteName) }
        return FavouritesStore(defaults: defaults, storageKey: "favs")
    }

    // MARK: - RatingView

    func testRatingViewFull() {
        assertSnapshot(of: RatingView(rating: 5.0), as: .image(layout: .sizeThatFits))
    }

    func testRatingViewHalf() {
        assertSnapshot(of: RatingView(rating: 4.5), as: .image(layout: .sizeThatFits))
    }

    func testRatingViewLow() {
        assertSnapshot(of: RatingView(rating: 1.2), as: .image(layout: .sizeThatFits))
    }

    // MARK: - FavouritesBadge

    func testFavouritesBadgeEmpty() {
        assertSnapshot(of: FavouritesBadge(count: 0), as: .image(layout: .sizeThatFits))
    }

    func testFavouritesBadgePopulated() {
        assertSnapshot(of: FavouritesBadge(count: 3), as: .image(layout: .sizeThatFits))
    }

    // MARK: - MessageView

    func testMessageViewEmptyState() {
        let view = MessageView(
            systemImage: AppTheme.Icon.heart,
            title: AppStrings.Favourites.emptyTitle,
            message: AppStrings.Favourites.emptyMessage
        )
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 320, height: 300)))
    }

    // MARK: - SakeShopRow

    func testSakeShopRow() {
        let view = SakeShopRow(shop: makeShop())
            .environmentObject(makeFavourites())
            .padding()
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 350, height: 110)))
    }

    func testSakeShopRowFavourited() {
        let favourites = makeFavourites()
        let shop = makeShop()
        favourites.toggle(shop)

        let view = SakeShopRow(shop: shop)
            .environmentObject(favourites)
            .padding()
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 350, height: 110)))
    }
}
