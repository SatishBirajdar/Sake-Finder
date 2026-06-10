import SwiftUI

/// Root container hosting the Popular and Favourite tabs.
///
/// Owns the shared ``SakeListViewModel`` (data source) and ``FavouritesStore``
/// (favourites state) and injects the store into the environment so any child
/// view can read or toggle favourites.
struct MainTabView: View {
    @StateObject private var viewModel = SakeListViewModel()
    @StateObject private var favourites = FavouritesStore()

    var body: some View {
        TabView {
            SakeListView(viewModel: viewModel)
                .tabItem { Label(AppStrings.Tab.popular, systemImage: AppTheme.Icon.popularTab) }

            FavouritesView(viewModel: viewModel)
                .tabItem { Label(AppStrings.Tab.favourite, systemImage: AppTheme.Icon.heartFill) }
        }
        .environmentObject(favourites)
        .task { await viewModel.loadIfNeeded() }
    }
}
