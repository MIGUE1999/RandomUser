import XCTest

@testable import RandomUser

final class DeleteUserUseCaseTests: XCTestCase {
    var sut: DeleteUserUseCase!
    var mockRepository: RandomUsersRepositoryMock!

    override func setUp() {
        super.setUp()
        mockRepository = RandomUsersRepositoryMock()
        sut = DeleteUserUseCase(randomUserRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_run_callsDeleteOnRepository() {
        // Given
        let indexToDelete = 3

        // When
        sut.run(at: indexToDelete)

        // Then
        XCTAssertEqual(mockRepository.deletedIndex, indexToDelete)
    }
}
