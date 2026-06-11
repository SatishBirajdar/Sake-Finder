//
//  TestFixtures.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import XCTest
@testable import Sake_Finder

/// Shared fixtures for the test target so individual test files don't each
/// redefine the same sample data.
enum SakeShopFixture {
    static func make(name: String = "Test Sake",
                     picture: String? = nil,
                     rating: Double = 4.5) -> SakeShop {
        SakeShop(
            name: name,
            description: "A test shop",
            picture: picture,
            rating: rating,
            address: "1 Test Street",
            coordinates: [0, 0],
            googleMapsLink: "https://maps.apple.com",
            website: "https://example.com"
        )
    }

    /// A `FavouritesStore` backed by an isolated `UserDefaults` suite.
    ///
    /// The suite is removed automatically when `testCase` finishes, so favourites
    /// never leak between tests. Pass `self` from the calling test.
    static func makeIsolatedFavouritesStore(on testCase: XCTestCase) -> FavouritesStore {
        let suiteName = "test.favourites.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            fatalError("Unable to create UserDefaults suite \(suiteName)")
        }
        // Capture only the Sendable suite name; removing the domain by name
        // avoids sending the non-Sendable `defaults` into the @Sendable closure.
        testCase.addTeardownBlock {
            UserDefaults.standard.removePersistentDomain(forName: suiteName)
        }
        return FavouritesStore(defaults: defaults, storageKey: "favs")
    }
}
