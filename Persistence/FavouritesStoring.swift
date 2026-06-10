//
//  FavouritesStoring.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// Abstraction for reading and mutating the user's favourite shops.
///
/// Views and view models depend on this contract rather than a concrete
/// implementation, so the persistence mechanism can be swapped or mocked.
protocol FavouritesStoring {
    /// Names of the shops currently marked as favourite.
    var favouriteNames: Set<String> { get }

    /// Adds the shop to favourites if absent, otherwise removes it.
    func toggle(_ shop: SakeShop)

    /// Returns `true` when the shop is currently a favourite.
    func isFavourite(_ shop: SakeShop) -> Bool
}
