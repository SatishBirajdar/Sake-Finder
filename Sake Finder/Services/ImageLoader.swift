//
//  ImageLoader.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import UIKit
import ImageIO

/// Loads, downsamples and caches remote images.
///
/// An `actor` serialises cache access and de-duplicates in-flight requests for
/// the same key, while the actual download + decode runs in a detached task so
/// multiple images load in parallel. Images are downsampled to the requested
/// pixel size with ImageIO, so a 50×50 thumbnail never holds a full-resolution
/// bitmap in memory.
actor ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSString, UIImage>()
    private var inFlight: [NSString: Task<UIImage, Error>] = [:]
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 200
    }

    /// Returns a cached or freshly-downloaded image downsampled so its largest
    /// edge is at most `maxPixelSize` pixels.
    func image(for url: URL, maxPixelSize: CGFloat) async throws -> UIImage {
        let key = "\(url.absoluteString)|\(Int(maxPixelSize))" as NSString

        if let cached = cache.object(forKey: key) {
            return cached
        }
        if let existing = inFlight[key] {
            return try await existing.value
        }

        let session = self.session
        let task = Task<UIImage, Error>.detached(priority: .userInitiated) {
            let (data, _) = try await session.data(from: url)
            guard let image = ImageLoader.downsample(data: data, maxPixelSize: maxPixelSize) else {
                throw URLError(.cannotDecodeContentData)
            }
            return image
        }
        inFlight[key] = task

        do {
            let image = try await task.value
            cache.setObject(image, forKey: key)
            inFlight.removeValue(forKey: key)
            return image
        } catch {
            inFlight.removeValue(forKey: key)
            throw error
        }
    }

    /// Decodes `data` into a thumbnail no larger than `maxPixelSize` on its
    /// longest edge, decoding directly at the target size.
    ///
    /// Falls back to a full decode if thumbnail generation isn't possible for the
    /// image (some sources fail `CGImageSourceCreateThumbnailAtIndex` with a
    /// `paramErr (-50)`), so a valid image always loads.
    nonisolated private static func downsample(data: Data, maxPixelSize: CGFloat) -> UIImage? {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions),
              CGImageSourceGetCount(source) > 0 else {
            return UIImage(data: data)
        }

        // ImageIO expects an integer pixel size.
        let maxDimension = Int(max(maxPixelSize, 1).rounded())
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            // Thumbnail generation unsupported for this image — decode it fully.
            return UIImage(data: data)
        }
        return UIImage(cgImage: cgImage)
    }
}
