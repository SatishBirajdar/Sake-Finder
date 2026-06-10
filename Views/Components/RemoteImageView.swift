import SwiftUI

/// Reusable remote image loader with consistent placeholder and failure states.
///
/// The image is drawn into a fixed container (sized by `width`/`height`, or
/// flexible width when `width` is `nil`) and clipped to it, so a loaded image
/// can never grow the layout beyond its container — preventing surrounding
/// padding from being pushed off-screen.
struct RemoteImageView: View {
    let url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var cornerRadius: CGFloat = AppTheme.Layout.thumbnailCornerRadius
    var contentMode: ContentMode = .fill

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .overlay { imageContent }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    @ViewBuilder
    private var imageContent: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                Image(systemName: AppTheme.Icon.photo)
                    .foregroundStyle(.secondary)
            @unknown default:
                Image(systemName: AppTheme.Icon.photo)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
