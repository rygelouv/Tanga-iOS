//
//  LibraryViewModelTests.swift
//  Tanga
//
//  Created by Rygel Louv on 16/02/2025.
//

import Testing
import Foundation
@testable import Tanga

struct MockFavoriteRepository: FavoriteRepositoryProtocol {
    var result: Result<[Favorite], Error>
    
    func getFavorites(userId: UserId) async -> Result<[Favorite], Error> {
        return result
    }
    
    func getFavoriteForUser(userId: UserId, summaryId: SummaryId) async -> Result<Favorite?, Error> {
        return .failure(NSError(domain: "", code: -1, userInfo: [:]))
    }
    
    func saveFavorite(userId: UserId, favorite: Favorite) async -> Result<FavoriteId, Error> {
        return .success(FavoriteId("mock-id"))
    }
    
    func deleteFavorite(favoriteId: FavoriteId) async -> Result<Void, Error> {
        return .success(())
    }
}


struct LibraryViewModelTests {

    @Test func testLoadFavorites_Success() async throws {
        // Arrange: Set up mock data
        let mockFavorites = [Favorite(id: "1", title: "Mock Book")]
        let mockRepository = MockFavoriteRepository(result: .success(mockFavorites))
        let viewModel = LibraryViewModel(favoriteRepository: mockRepository)

        // Act: Call loadFavorites()
        await viewModel.loadFavorites()

        // Assert: Verify the expected values
        #expect(viewModel.favorites?.count == 1)
        #expect(viewModel.favorites?.first?.title == "Mock Book")
    }

    @Test func testLoadFavorites_Failure() async throws {
        // Arrange: Simulate failure case
        let mockRepository = MockFavoriteRepository(result: .failure(NSError(domain: "", code: -1, userInfo: nil)))
        let viewModel = LibraryViewModel(favoriteRepository: mockRepository)

        // Act: Call loadFavorites()
        await viewModel.loadFavorites()

        // Assert: Ensure favorites remain nil
        #expect(viewModel.favorites == nil)
    }

}
