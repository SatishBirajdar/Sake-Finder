import Foundation

final class FavouritesStore: ObservableObject {
    @Published private(set) var favouriteNames: Set<String>

    private let storageKey = "favouriteShops"

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: "favouriteShops") ?? []
        favouriteNames = Set(saved)
    }

    func toggle(_ shop: SakeShop) {
        if favouriteNames.contains(shop.name) {
            favouriteNames.remove(shop.name)
        } else {
            favouriteNames.insert(shop.name)
        }
        UserDefaults.standard.set(Array(favouriteNames), forKey: storageKey)
    }

    func isFavourite(_ shop: SakeShop) -> Bool {
        favouriteNames.contains(shop.name)
    }
}
