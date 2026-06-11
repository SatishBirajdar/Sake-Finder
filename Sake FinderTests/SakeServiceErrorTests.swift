//
//  SakeServiceErrorTests.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import XCTest
@testable import Sake_Finder

final class SakeServiceErrorTests: XCTestCase {

    func testProvidesUserFacingDescription() {
        XCTAssertEqual(SakeServiceError.invalidResponse.errorDescription, AppStrings.ErrorMessage.loadFailed)
        XCTAssertEqual(SakeServiceError.decodingFailed.errorDescription, AppStrings.ErrorMessage.loadFailed)
        XCTAssertEqual(SakeServiceError.unreachable.errorDescription, AppStrings.ErrorMessage.loadFailed)
    }
}
