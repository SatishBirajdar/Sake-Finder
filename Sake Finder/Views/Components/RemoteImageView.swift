//
//  RemoteImageView.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import SwiftUI
import UIKit

/// Reusable remote image view backed by ``ImageLoader``.
///
/// Images are cached across cell reuse and downsampled to the view's target
/// pixel size, so long lists don't decode full-resolution bitmaps for small
/// thumbnails. The image is drawn into a fixed container (sized by
/// `width`/`height`, or flexible width when `width` is `nil`) and clipped to it,
/// so a loaded image can never grow the layout beyond its container.
struct RemoteImageView: View {
    let url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var cornerRadius: CGFloat = AppTheme.Layout.thumbnailCornerRadius
    var contentMode: ContentMode = .fill
    /// When set, a centred spinner of this colour is shown while downloading.
    var loadingTint: Color?

    @Environment(\.displayScale) private var displayScale
    @State private var phase: Phase = .loading

    private enum Phase {
        case loading
        case success(UIImage)
        case failure
    }

    /// Largest edge (in pixels) the decoded image needs. Uses the known frame
    /// dimensions, falling back to a full-width-ish bound when width is flexible.
    private var maxPixelSize: CGFloat {
        let points = max(width ?? 1000, height ?? 1000)
        return points * displayScale
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .overlay { content }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .task(id: url) { await load() }
    }

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .loading:
            if let loadingTint {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(loadingTint)
            } else {
                Image(systemName: AppTheme.Icon.photo)
                    .foregroundStyle(.secondary)
            }
        case .success(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        case .failure:
            Image(systemName: AppTheme.Icon.photo)
                .foregroundStyle(.secondary)
        }
    }

    private func load() async {
        phase = .loading

        guard let url else {
            phase = .failure
            return
        }

        do {
            let image = try await ImageLoader.shared.image(for: url, maxPixelSize: maxPixelSize)
            guard !Task.isCancelled else { return }
            phase = .success(image)
        } catch {
            guard !Task.isCancelled else { return }
            phase = .failure
        }
    }
}
