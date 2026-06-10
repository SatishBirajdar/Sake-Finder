import SwiftUI

struct SakeListView: View {
    let shops: [SakeShop]
    let isLoading: Bool
    let errorMessage: String?

    @State private var searchText = ""
    @State private var isSearching = false
    @EnvironmentObject private var favourites: FavouritesStore

    private var filteredShops: [SakeShop] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return shops
        }
        return shops.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading sake shops...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else {
                    List(filteredShops) { shop in
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
            .navigationTitle(isSearching ? "" : "Sake Finder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
                        Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                            .foregroundStyle(.secondary)
                    }
                }

                if isSearching {
                    ToolbarItem(placement: .principal) {
                        TextField("Search shops", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .frame(minWidth: 200)
                    }
                }
            }
        }
    }
}

private struct FavouritesBadge: View {
    let count: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: count > 0 ? "heart.fill" : "heart")
                .foregroundStyle(count > 0 ? .red : .secondary)
            if count > 0 {
                Text("\(count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.red)
            }
        }
        .fixedSize()
    }
}

struct SakeShopRow: View {
    let shop: SakeShop
    @EnvironmentObject private var favourites: FavouritesStore

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            AsyncImage(url: shop.pictureURL) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                        .frame(width: 56, height: 56)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 56, height: 56)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(shop.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Label(shop.address, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                RatingView(rating: shop.rating)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                favourites.toggle(shop)
            } label: {
                Image(systemName: favourites.isFavourite(shop) ? "heart.fill" : "heart")
                    .foregroundStyle(favourites.isFavourite(shop) ? .red : .secondary)
                    .font(.system(size: 18))
                    .padding(4)
            }
            .buttonStyle(.borderless)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }
}
