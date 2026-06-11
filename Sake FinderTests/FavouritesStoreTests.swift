//
//  FavouritesStoreTests.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import XCTest
@testable import Sake_Finder

final class FavouritesStoreTests: XCTestCase {

    func testToggleAddsAndRemoves() {
        let store = SakeShopFixture.makeIsolatedFavouritesStore(on: self)
        let shop = SakeShopFixture.make()

        XCTAssertFalse(store.isFavourite(shop))

        store.toggle(shop)
        XCTAssertTrue(store.isFavourite(shop))

        store.toggle(shop)
        XCTAssertFalse(store.isFavourite(shop))
    }

    func testPersistsAcrossInstances() {
        let suiteName = "test.favourites.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let shop = SakeShopFixture.make(name: "Persisted Sake")
        let first = FavouritesStore(defaults: defaults, storageKey: "favs")
        first.toggle(shop)

        let second = FavouritesStore(defaults: defaults, storageKey: "favs")
        XCTAssertTrue(second.isFavourite(shop))
    }
}
