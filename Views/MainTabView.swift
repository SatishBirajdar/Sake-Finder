import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = SakeListViewModel()
    @StateObject private var favourites = FavouritesStore()
    @State private var hasLoadedOnce = false

    var body: some View {
        TabView {
            SakeListView(
                shops: viewModel.shops,
                isLoading: viewModel.isLoading,
                errorMessage: viewModel.errorMessage
            )
            .tabItem { Label("Popular", systemImage: "list.star") }

            FavouritesView(shops: viewModel.shops.filter { favourites.isFavourite($0) })
                .tabItem { Label("Favourite", systemImage: "heart.fill") }
        }
        .environmentObject(favourites)
        .task {
            guard !hasLoadedOnce else { return }
            hasLoadedOnce = true
            await viewModel.loadShops()
        }
    }
}
