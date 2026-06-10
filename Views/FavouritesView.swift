//
//  FavouritesView.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI

/// The "Favourite" tab: shows shops the user has favourited, or an empty state.
///
/// Derives its content reactively from the shared shops (``SakeListViewModel``)
/// and the favourites stored in the environment.
struct FavouritesView: View {
    @ObservedObject var viewModel: SakeListViewModel
    @EnvironmentObject private var favourites: FavouritesStore

    private var favouriteShops: [SakeShop] {
        viewModel.shops.filter { favourites.isFavourite($0) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favouriteShops.isEmpty {
                    MessageView(
                        systemImage: AppTheme.Icon.heart,
                        title: AppStrings.Favourites.emptyTitle,
                        message: AppStrings.Favourites.emptyMessage
                    )
                } else {
                    ShopListView(shops: favouriteShops)
                }
            }
            .navigationTitle(AppStrings.Favourites.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
