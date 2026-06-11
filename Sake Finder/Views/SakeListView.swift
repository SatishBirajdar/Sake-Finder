//
//  SakeListView.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI

/// The "Popular" tab: a searchable, refreshable list of all sake shops.
///
/// Observes the shared ``SakeListViewModel`` for data and delegates rows,
/// list styling and state messages to reusable components.
struct SakeListView: View {
    @ObservedObject var viewModel: SakeListViewModel
    @EnvironmentObject private var favourites: FavouritesStore

    @State private var searchText = ""
    /// Trails `searchText` by a short delay so filtering doesn't run on every keystroke.
    @State private var debouncedQuery = ""

    private static let searchDebounce = Duration.milliseconds(250)

    private var visibleShops: [SakeShop] {
        viewModel.shops(matching: debouncedQuery)
    }

    private var isSearching: Bool {
        !debouncedQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(AppStrings.List.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
        }
        .searchable(text: $searchText, prompt: AppStrings.List.searchPlaceholder)
        .task(id: searchText) {
            // Cancelled and restarted on each keystroke; only the final pause commits.
            guard (try? await Task.sleep(for: Self.searchDebounce)) != nil else { return }
            debouncedQuery = searchText
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            MessageView(
                systemImage: AppTheme.Icon.warning,
                title: errorMessage,
                tint: .orange,
                actionTitle: AppStrings.ErrorMessage.retry,
                action: { Task { await viewModel.retry() } },
                actionIdentifier: AccessibilityID.ShopList.retryButton
            )
            .accessibilityIdentifier(AccessibilityID.ShopList.errorMessage)
        } else if visibleShops.isEmpty && isSearching {
            MessageView(
                systemImage: AppTheme.Icon.search,
                title: AppStrings.List.noResultsTitle,
                message: AppStrings.List.noResultsMessage
            )
            .accessibilityIdentifier(AccessibilityID.ShopList.noResultsMessage)
        } else {
            ShopListView(shops: visibleShops)
                .accessibilityIdentifier(AccessibilityID.ShopList.list)
                .refreshable { await viewModel.retry() }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text(AppStrings.List.loading)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(AccessibilityID.ShopList.loadingIndicator)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            FavouritesBadge(count: favourites.favouriteNames.count)
                .accessibilityIdentifier(AccessibilityID.ShopList.favouritesBadge)
        }
    }
}
