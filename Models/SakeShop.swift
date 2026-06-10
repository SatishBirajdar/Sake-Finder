import Foundation

/// A single sake shop returned by the API / sample data.
///
/// - Note: ``id`` is generated locally and is only stable within a single decode
///   pass. Persisted references (e.g. favourites) should key off ``name`` rather
///   than ``id``.
struct SakeShop: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let picture: String?
    let rating: Double
    let address: String
    let coordinates: [Double]
    let googleMapsLink: String
    let website: String

    enum CodingKeys: String, CodingKey {
        case name, description, picture, rating, address, coordinates
        case googleMapsLink = "google_maps_link"
        case website
    }

    /// URL of the shop's photo, if a valid string is present.
    var pictureURL: URL? {
        guard let picture, let url = URL(string: picture) else { return nil }
        return url
    }

    /// Google Maps link for the shop, if valid.
    var mapsURL: URL? {
        URL(string: googleMapsLink)
    }

    /// The shop's website, if valid.
    var websiteURL: URL? {
        URL(string: website)
    }

    /// Rating formatted to one decimal place for display.
    var ratingLabel: String {
        String(format: "%.1f", rating)
    }
}
