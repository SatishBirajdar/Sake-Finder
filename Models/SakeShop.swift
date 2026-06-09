import Foundation

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

    var pictureURL: URL? {
        guard let picture, let url = URL(string: picture) else { return nil }
        return url
    }

    var mapsURL: URL? {
        URL(string: googleMapsLink)
    }

    var websiteURL: URL? {
        URL(string: website)
    }

    var ratingLabel: String {
        String(format: "%.1f", rating)
    }
}
