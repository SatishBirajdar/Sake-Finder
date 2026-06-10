import Foundation

@MainActor
final class SakeListViewModel: ObservableObject {
    @Published var shops: [SakeShop] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: any SakeServiceProtocol & Sendable

    init(service: any SakeServiceProtocol & Sendable = SakeAPIClient()) {
        self.service = service
    }

    func loadShops() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await service.fetchSakeShops()
            shops = result
        } catch {
            errorMessage = "Unable to load sake shops right now."
        }

        isLoading = false
    }
}
