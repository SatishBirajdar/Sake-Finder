import SwiftUI

/// Centralised visual constants.
///
/// Keeping layout metrics and SF Symbol names in one place avoids scattering
/// "magic numbers" and string literals throughout the view code, and makes
/// global styling changes a single-line edit.
enum AppTheme {

    /// Spacing, sizing and corner-radius values used across the UI.
    enum Layout {
        static let cardCornerRadius: CGFloat = 18
        static let thumbnailCornerRadius: CGFloat = 4
        static let detailImageCornerRadius: CGFloat = 24

        static let rowSpacing: CGFloat = 14
        static let contentSpacing: CGFloat = 16
        static let textSpacing: CGFloat = 6
        static let messageSpacing: CGFloat = 16

        static let thumbnailSize: CGFloat = 50
        static let detailImageHeight: CGFloat = 220
        static let cardPadding: CGFloat = 12

        static let listRowVerticalInset: CGFloat = 6
        static let listRowHorizontalInset: CGFloat = 14
    }

    /// SF Symbol identifiers referenced by more than one view.
    enum Icon {
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let search = "magnifyingglass"
        static let close = "xmark"
        static let photo = "photo"
        static let star = "star"
        static let starFill = "star.fill"
        static let starHalf = "star.leadinghalf.filled"
        static let mapPin = "mappin.and.ellipse"
        static let location = "location"
        static let globe = "globe"
        static let openLink = "arrow.up.right.square"
        static let popularTab = "list.star"
        static let warning = "exclamationmark.triangle"
        static let noImage = "noImage"
    }
}
