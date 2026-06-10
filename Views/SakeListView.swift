import SwiftUI

/// The "Popular" tab: a searchable, refreshable list of all sake shops.
///
/// Observes the shared ``SakeListViewModel`` for data and delegates rows,
/// list styling and state messages to reusable components.
struct SakeListView: View {
    @ObservedObject var viewModel: SakeListViewModel
    @EnvironmentObject private var favourites: FavouritesStore

    @State private var searchText = ""

    private var visibleShops: [SakeShop] {
        viewModel.shops(matching: searchText)
    }

    private var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(AppStrings.List.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
        }
        .searchable(text: $searchText, prompt: AppStrings.List.searchPlaceholder)
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
                action: { Task { await viewModel.retry() } }
            )
        } else if visibleShops.isEmpty && isSearching {
            MessageView(
                systemImage: AppTheme.Icon.search,
                title: AppStrings.List.noResultsTitle,
                message: AppStrings.List.noResultsMessage
            )
        } else {
            ShopListView(shops: visibleShops)
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
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            FavouritesBadge(count: favourites.favouriteNames.count)
        }
    }
}
