import XCTest
@testable import RandomUser

final class SearchUsersUseCaseTests: XCTestCase {
    var sut: SearchUsersUseCase!

    override func setUp() {
        super.setUp()
        sut = SearchUsersUseCase()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_run_withEmptySearchText_returnsAllUsers() {
        // Given
        let users = [
            RandomUsersModel.dummyInsatance(),
            makeSecondUser()
        ]
        let searchText = ""

        // When
        let filtered = sut.run(users: users, searchText: searchText)

        // Then
        XCTAssertEqual(filtered.count, users.count)
    }

    func test_run_filtersByFullName() {
        // Given
        let users = [
            RandomUsersModel.dummyInsatance(),
            makeSecondUser()
        ]
        let searchText = "john"

        // When
        let filtered = sut.run(users: users, searchText: searchText)

        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.fullName, "John Doe")
    }

    func test_run_filtersByEmail() {
        // Given
        let users = [
            RandomUsersModel.dummyInsatance(),
            makeSecondUser()
        ]
        let searchText = "jane@EXAMPLE.com"

        // When
        let filtered = sut.run(users: users, searchText: searchText)

        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.email, "jane@example.com")
    }

    func test_run_returnsEmpty_whenNoMatch() {
        // Given
        let users = [
            RandomUsersModel.dummyInsatance(),
            makeSecondUser()
        ]
        let searchText = "nonexistent"

        // When
        let filtered = sut.run(users: users, searchText: searchText)

        // Then
        XCTAssertTrue(filtered.isEmpty)
    }
}

private extension SearchUsersUseCaseTests {
    func makeSecondUser() -> RandomUsersModel {
        RandomUsersModel(gender: "female", name: "Jane", surname: "Smith", fullName: "Jane Smith", email: "jane@example.com", phone: "", pictureURL: "", street: "", city: "", state: "", registeredDate: "")
    }
}
