//
//  SakeServiceProtocol.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// Abstraction over the source that provides ``SakeShop`` data.
///
/// Callers depend on this protocol rather than a concrete client, which keeps
/// view models decoupled from networking details and allows a mock to be
/// injected in tests (Dependency Inversion).
protocol SakeServiceProtocol: Sendable {
    /// Fetches the list of sake shops.
    /// - Throws: ``SakeServiceError`` when the data cannot be retrieved or decoded.
    func fetchSakeShops() async throws -> [SakeShop]
}
