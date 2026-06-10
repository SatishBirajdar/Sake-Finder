//
//  FavouritesStore.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// `UserDefaults`-backed implementation of ``FavouritesStoring``.
///
/// Favourites are keyed by shop name because ``SakeShop/id`` is regenerated each
/// time the JSON is decoded and is therefore not stable across launches.
///
/// `UserDefaults` is injected so the store can be exercised in tests against an
/// isolated suite rather than the app's shared defaults.
final class FavouritesStore: ObservableObject, FavouritesStoring {
    @Published private(set) var favouriteNames: Set<String>

    private let defaults: UserDefaults
    private let storageKey: String

    private static let defaultStorageKey = "favouriteShops"

    init(defaults: UserDefaults = .standard,
         storageKey: String = FavouritesStore.defaultStorageKey) {
        self.defaults = defaults
        self.storageKey = storageKey
        let saved = defaults.stringArray(forKey: storageKey) ?? []
        self.favouriteNames = Set(saved)
    }

    func toggle(_ shop: SakeShop) {
        if favouriteNames.contains(shop.name) {
            favouriteNames.remove(shop.name)
        } else {
            favouriteNames.insert(shop.name)
        }
        persist()
    }

    func isFavourite(_ shop: SakeShop) -> Bool {
        favouriteNames.contains(shop.name)
    }

    private func persist() {
        defaults.set(Array(favouriteNames), forKey: storageKey)
    }
}
