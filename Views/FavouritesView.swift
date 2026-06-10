import SwiftUI

struct FavouritesView: View {
    let shops: [SakeShop]
    @EnvironmentObject private var favourites: FavouritesStore

    var body: some View {
        NavigationStack {
            Group {
                if shops.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart")
                            .font(.system(size: 52))
                            .foregroundStyle(.secondary)
                        Text("No favourites yet")
                            .font(.headline)
                        Text("Tap the heart on any shop to save it here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(shops) { shop in
                        NavigationLink(destination: SakeDetailView(shop: shop)) {
                            SakeShopRow(shop: shop)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
