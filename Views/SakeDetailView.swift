import SwiftUI

struct SakeDetailView: View {
    let shop: SakeShop

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: shop.pictureURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .frame(height: 220)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    case .failure:
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .frame(height: 220)
                            .overlay(Image(systemName: "photo"))
                    @unknown default:
                        EmptyView()
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(shop.name)
                        .font(.largeTitle)
                        .bold()

                    RatingView(rating: shop.rating)

                    Text(shop.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Label("Address", systemImage: "mappin.and.ellipse")
                        .font(.headline)

                    if let mapsURL = shop.mapsURL {
                        Link(destination: mapsURL) {
                            Label(shop.address, systemImage: "location")
                                .foregroundStyle(.blue)
                        }
                    } else {
                        Text(shop.address)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Label("Visit shop", systemImage: "globe")
                        .font(.headline)

                    if let websiteURL = shop.websiteURL {
                        Link(destination: websiteURL) {
                            Label("Open website in browser", systemImage: "arrow.up.right.square")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Shop Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
