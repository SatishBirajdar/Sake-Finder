import SwiftUI

struct SakeListView: View {
    @StateObject private var viewModel = SakeListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading sake shops...")
                } else if let errorMessage = viewModel.errorMessage {
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
                    List(viewModel.shops) { shop in
                        NavigationLink(destination: SakeDetailView(shop: shop)) {
                            SakeShopRow(shop: shop)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Sake Finder")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Label("Discover", systemImage: "magnifyingglass")
                        .foregroundStyle(.secondary)
                }
            }
            .task {
                await viewModel.loadShops()
            }
        }
    }
}

struct SakeShopRow: View {
    let shop: SakeShop

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
                    .font(.headline)
                    .foregroundStyle(.primary)

                Label(shop.address, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                RatingView(rating: shop.rating)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}
