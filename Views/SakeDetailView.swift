import SwiftUI

struct SakeDetailView: View {
    let shop: SakeShop
    @State private var showSpinner = true
    @State private var spinnerStartTime = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: shop.pictureURL) { phase in
                    switch phase {
                    case .empty:
                        Image("noImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 32, height: 220)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .overlay(
                                Group {
                                    if showSpinner && Date().timeIntervalSince(spinnerStartTime) < 4 {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .tint(.orange)
                                    }
                                }
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 32, height: 220)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    case .failure:
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .overlay(Image(systemName: "photo"))
                    @unknown default:
                        EmptyView()
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(shop.name)
                        .font(.title2.weight(.semibold))

                    RatingView(rating: shop.rating)

                    Text(shop.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("Address", systemImage: "mappin.and.ellipse")
                        .font(.subheadline.weight(.semibold))

                    if let mapsURL = shop.mapsURL {
                        Link(destination: mapsURL) {
                            Label(shop.address, systemImage: "location")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    } else {
                        Text(shop.address)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("Visit shop", systemImage: "globe")
                        .font(.subheadline.weight(.semibold))

                    if let websiteURL = shop.websiteURL {
                        Link(destination: websiteURL) {
                            Label("Open website in browser", systemImage: "arrow.up.right.square")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            showSpinner = true
            spinnerStartTime = Date()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showSpinner = false
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Shop Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
