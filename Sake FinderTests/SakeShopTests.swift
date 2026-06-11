//
//  SakeShopTests.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import XCTest
@testable import Sake_Finder

final class SakeShopTests: XCTestCase {

    func testUrlsAreBuiltFromProperties() {
        let shop = SakeShopFixture.make(picture: "https://example.com/image.jpg")

        XCTAssertNotNil(shop.pictureURL)
        XCTAssertNotNil(shop.mapsURL)
        XCTAssertNotNil(shop.websiteURL)
    }

    func testPictureURLIsNilWhenAbsent() {
        let shop = SakeShopFixture.make(picture: nil)

        XCTAssertNil(shop.pictureURL)
    }

    func testRatingLabelFormatsToOneDecimal() {
        XCTAssertEqual(SakeShopFixture.make(rating: 4.5).ratingLabel, "4.5")
        XCTAssertEqual(SakeShopFixture.make(rating: 4.0).ratingLabel, "4.0")
    }
}
