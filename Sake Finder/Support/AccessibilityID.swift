//
//  AccessibilityID.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// Stable accessibility identifiers used by UI tests.
///
/// Centralising them (rather than scattering string literals across views) keeps
/// the identifiers consistent between the app and its UI tests and avoids typos.
enum AccessibilityID {

    enum Tab {
        static let popular = "tab.popular"
        static let favourite = "tab.favourite"
    }

    enum Launch {
        static let root = "launch.root"
    }

    enum ShopList {
        static let list = "shopList.list"
        static let loadingIndicator = "shopList.loadingIndicator"
        static let errorMessage = "shopList.errorMessage"
        static let retryButton = "shopList.retryButton"
        static let noResultsMessage = "shopList.noResultsMessage"
        static let favouritesBadge = "shopList.favouritesBadge"
    }

    enum Favourites {
        static let list = "favourites.list"
        static let emptyState = "favourites.emptyState"
    }

    enum Detail {
        static let scrollView = "detail.scrollView"
        static let name = "detail.name"
        static let rating = "detail.rating"
        static let description = "detail.description"
        static let favouriteButton = "detail.favouriteButton"
        static let addressLink = "detail.addressLink"
        static let websiteLink = "detail.websiteLink"
    }

    enum Row {
        static let favouriteButton = "shopRow.favouriteButton"

        /// Per-shop identifier so a UI test can tap a specific row.
        static func cell(_ name: String) -> String { "shopRow.\(name)" }
    }
}
