import Foundation

/// Concrete networking client for fetching sake shops.
///
/// Fetches from the configured remote endpoint and validates the HTTP response.
/// When no endpoint is configured, or a transient network error occurs, it
/// gracefully degrades to the bundled sample data. Decoding and unreachable
/// failures are surfaced as ``SakeServiceError`` so the UI can react.
final class SakeAPIClient: SakeServiceProtocol, @unchecked Sendable {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let decoder: JSONDecoder

    init(session: URLSession = .shared,
         configuration: APIConfiguration = .default,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }

    func fetchSakeShops() async throws -> [SakeShop] {
        guard let endpoint = configuration.shopsEndpoint else {
            return try loadSampleData()
        }

        do {
            let (data, response) = try await session.data(from: endpoint)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                throw SakeServiceError.invalidResponse
            }
            return try decode(data)
        } catch let error as SakeServiceError {
            throw error
        } catch is DecodingError {
            throw SakeServiceError.decodingFailed
        } catch {
            // Transient connectivity issue: fall back to bundled data so the
            // user still sees content rather than an empty screen.
            return try loadSampleData()
        }
    }

    /// Loads and decodes the JSON response bundled with the app.
    private func loadSampleData() throws -> [SakeShop] {
        guard let url = Bundle.main.url(forResource: configuration.sampleResourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw SakeServiceError.unreachable
        }
        return try decode(data)
    }

    private func decode(_ data: Data) throws -> [SakeShop] {
        do {
            return try decoder.decode([SakeShop].self, from: data)
        } catch {
            throw SakeServiceError.decodingFailed
        }
    }
}
