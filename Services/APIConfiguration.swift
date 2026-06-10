//
//  APIConfiguration.swift
//  Sake Finder
//
//  Created by Satish Birajdar on 10/06/2026.
//

import Foundation

/// Configuration for the sake networking layer.
///
/// Holding the endpoint here (rather than hardcoding a URL inside the client)
/// keeps networking values in one place and makes it trivial to point the app
/// at a different environment.
struct APIConfiguration {
    /// Remote endpoint for the shop list. When `nil`, the client falls back to
    /// the bundled sample response so the app remains usable offline / in demos.
    let shopsEndpoint: URL?

    /// Filename (without extension) of the bundled sample JSON response.
    let sampleResourceName: String

    static let `default` = APIConfiguration(
        shopsEndpoint: nil,
        sampleResourceName: "sample-sake-response"
    )
}
