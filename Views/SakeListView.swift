import SwiftUI

/// The "Popular" tab: a searchable list of all sake shops.
///
/// Observes the shared ``SakeListViewModel`` for data and delegates rows,
/// list styling and state messages to reusable components.
struct SakeListView: View {
    @ObservedObject var viewModel: SakeListViewModel
    @EnvironmentObject private var favourites: FavouritesStore

    @State private var searchText = ""
    @State private var isSearching = false

    private var visibleShops: [SakeShop] {
        viewModel.shops(matching: searchText)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(isSearching ? "" : AppStrings.List.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
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
                action: { Task { await viewModel.retry() } }
            )
        } else {
            ShopListView(shops: visibleShops)
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

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation(.easeInOut) {
                    isSearching.toggle()
                    if !isSearching { searchText = "" }
                }
            } label: {
                Image(systemName: isSearching ? AppTheme.Icon.close : AppTheme.Icon.search)
                    .foregroundStyle(.secondary)
            }
        }

        if isSearching {
            ToolbarItem(placement: .principal) {
                TextField(AppStrings.List.searchPlaceholder, text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: AppTheme.Layout.searchFieldMinWidth)
            }
        }
    }
}
