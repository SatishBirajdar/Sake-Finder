//
//  MockSakeService.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation
@testable import Sake_Finder

/// Test double for ``SakeServiceProtocol`` that returns a configurable result
/// and records how many times it was called.
final class MockSakeService: SakeServiceProtocol, @unchecked Sendable {
    var result: Result<[SakeShop], Error>
    private(set) var fetchCallCount = 0

    init(result: Result<[SakeShop], Error> = .success([])) {
        self.result = result
    }

    /// Convenience initialiser for the common "return these shops" case.
    convenience init(shops: [SakeShop]) {
        self.init(result: .success(shops))
    }

    func fetchSakeShops() async throws -> [SakeShop] {
        fetchCallCount += 1
        return try result.get()
    }
}
