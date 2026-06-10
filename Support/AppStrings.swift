//
//  AppStrings.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// User-facing copy for the app, grouped by feature.
///
/// Centralising strings keeps wording consistent, removes hardcoded literals
/// from views, and provides a single point to introduce localisation later.
enum AppStrings {

    enum Tab {
        static let popular = "Popular"
        static let favourite = "Favourite"
    }

    enum List {
        static let title = "Sake Finder"
        static let searchPlaceholder = "Search shops"
        static let loading = "Loading sake shops..."
        static let noResultsTitle = "No matches"
        static let noResultsMessage = "No shops match your search. Try a different term."
    }

    enum Favourites {
        static let title = "Favourites"
        static let emptyTitle = "No favourites yet"
        static let emptyMessage = "Tap the heart on any shop to save it here."
    }

    enum Detail {
        static let title = "Shop Details"
        static let addressSection = "Address"
        static let visitSection = "Visit shop"
        static let openWebsite = "Open website in browser"
    }

    enum Favourite {
        static let add = "Add to favourites"
        static let remove = "Remove from favourites"
    }

    enum ErrorMessage {
        static let loadFailed = "Unable to load sake shops right now. Please try again."
        static let retry = "Try Again"
    }
}
