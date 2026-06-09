import Foundation

protocol SakeServiceProtocol {
    func fetchSakeShops() async throws -> [SakeShop]
}

final class SakeAPIClient: SakeServiceProtocol {
    private let session: URLSession
    private let endpoint: URL?

    init(session: URLSession = .shared,
         endpoint: URL? = nil) {
        self.session = session
        self.endpoint = endpoint
    }

    func fetchSakeShops() async throws -> [SakeShop] {
        if let endpoint {
            do {
                let (data, _) = try await session.data(from: endpoint)
                return try JSONDecoder().decode([SakeShop].self, from: data)
            } catch {
                return try loadSampleData()
            }
        }

        return try loadSampleData()
    }

    private func loadSampleData() throws -> [SakeShop] {
        guard let localURL = Bundle.main.url(forResource: "sample-sake-response", withExtension: "json"),
              let data = try? Data(contentsOf: localURL) else {
            throw URLError(.resourceUnavailable)
        }

        return try JSONDecoder().decode([SakeShop].self, from: data)
    }
}
