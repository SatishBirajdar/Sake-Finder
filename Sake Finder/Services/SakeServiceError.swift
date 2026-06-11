//
//  SakeServiceError.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// Errors produced by the sake networking layer.
///
/// Conforms to `LocalizedError` so each case maps to user-facing copy that can
/// be surfaced directly in the UI.
enum SakeServiceError: LocalizedError, Equatable {
    /// The server returned a non-success HTTP status code.
    case invalidResponse
    /// The payload could not be decoded into ``SakeShop`` values.
    case decodingFailed
    /// No data source (remote or bundled) could be reached.
    case unreachable

    var errorDescription: String? {
        // A single, friendly message is shown for every failure mode; the
        // specific case is retained for logging and testing.
        AppStrings.ErrorMessage.loadFailed
    }
}
