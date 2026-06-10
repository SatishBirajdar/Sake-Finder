import Foundation

/// Presentation logic for the shop list: loads data through an injected
/// ``SakeServiceProtocol``, tracks loading / error state, and provides search
/// filtering. The dependency is injected to keep the view model testable.
@MainActor
final class SakeListViewModel: ObservableObject {
    @Published private(set) var shops: [SakeShop] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: any SakeServiceProtocol
    private var hasLoaded = false

    init(service: any SakeServiceProtocol = SakeAPIClient()) {
        self.service = service
    }

    /// Loads shops only the first time it is called; subsequent calls are no-ops.
    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        await load()
    }

    /// Forces a reload, e.g. when the user taps "Try Again".
    func retry() async {
        await load()
    }

    /// Returns shops whose name matches `query`. An empty or whitespace-only
    /// query returns all shops.
    func shops(matching query: String) -> [SakeShop] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return shops }
        return shops.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil

        do {
            shops = try await service.fetchSakeShops()
            hasLoaded = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? AppStrings.ErrorMessage.loadFailed
        }

        isLoading = false
    }
}
