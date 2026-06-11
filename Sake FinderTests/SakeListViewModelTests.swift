//
//  SakeListViewModelTests.swift
//  Sake FinderTests
//
//  Created by Satish Birajdar on 10/06/2026.
//

import XCTest
@testable import Sake_Finder

@MainActor
final class SakeListViewModelTests: XCTestCase {

    func testLoadsShopsFromInjectedService() async {
        let service = MockSakeService(shops: [
            SakeShopFixture.make(name: "Test Sake"),
            SakeShopFixture.make(name: "Second Sake"),
        ])
        let viewModel = SakeListViewModel(service: service)

        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.shops.count, 2)
        XCTAssertEqual(viewModel.shops.first?.name, "Test Sake")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadIfNeededOnlyFetchesOnce() async {
        let service = MockSakeService(shops: [SakeShopFixture.make()])
        let viewModel = SakeListViewModel(service: service)

        await viewModel.loadIfNeeded()
        await viewModel.loadIfNeeded()

        XCTAssertEqual(service.fetchCallCount, 1)
    }

    func testRetryFetchesAgain() async {
        let service = MockSakeService(shops: [SakeShopFixture.make()])
        let viewModel = SakeListViewModel(service: service)

        await viewModel.loadIfNeeded()
        await viewModel.retry()

        XCTAssertEqual(service.fetchCallCount, 2)
    }

    func testFailureSurfacesUserFacingError() async {
        let service = MockSakeService(result: .failure(SakeServiceError.unreachable))
        let viewModel = SakeListViewModel(service: service)

        await viewModel.loadIfNeeded()

        XCTAssertTrue(viewModel.shops.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, AppStrings.ErrorMessage.loadFailed)
    }

    func testShopsMatchingFiltersByName() async {
        let service = MockSakeService(shops: [
            SakeShopFixture.make(name: "Nagano Brewery"),
            SakeShopFixture.make(name: "Tokyo Sake House"),
        ])
        let viewModel = SakeListViewModel(service: service)
        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.shops(matching: "nagano").count, 1)
        XCTAssertEqual(viewModel.shops(matching: "   ").count, 2)
        XCTAssertEqual(viewModel.shops(matching: "").count, 2)
    }
}
