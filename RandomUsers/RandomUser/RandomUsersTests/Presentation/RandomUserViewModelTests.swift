import XCTest
import Combine

@testable import RandomUser

final class RandomUsersViewModelTests: XCTestCase {
    private var sut: RandomUsersViewModel!
    private var getRandomUsersUseCase: GetRandomUsersUseCaseMock!
    private var deleteUserUseCase: DeleteUserUseCaseMock!
    private var searchUsersUseCase: SearchUsersUseCaseMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        getRandomUsersUseCase = GetRandomUsersUseCaseMock()
        deleteUserUseCase = DeleteUserUseCaseMock()
        searchUsersUseCase = SearchUsersUseCaseMock()
        sut = RandomUsersViewModel(
            getRandomUsersUseCase: getRandomUsersUseCase,
            deleteUserUseCase: deleteUserUseCase,
            searchUseCase: searchUsersUseCase
        )
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        getRandomUsersUseCase = nil
        deleteUserUseCase = nil
        searchUsersUseCase = nil
        super.tearDown()
    }

    func test_loadUsers_success_appendsUsersAndSetsFilteredUsers() {
        // Given
        let users = [
            makeUser(fullName: "John Doe", email: "john@example.com"),
            makeUser(fullName: "Jane Smith", email: "jane@example.com")
        ]
        getRandomUsersUseCase.usersToReturn = users

        let expectationLoading = expectation(description: "Loading changes")
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading { expectationLoading.fulfill() }
            }
            .store(in: &cancellables)

        let expectationFilteredUsers = expectation(description: "Filtered users updated")
        sut.$filteredUsers
            .dropFirst()
            .sink { filtered in
                if filtered.count == users.count {
                    expectationFilteredUsers.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        sut.loadUsers()

        // Then
        wait(for: [expectationLoading, expectationFilteredUsers], timeout: 1)
        XCTAssertEqual(sut.filteredUsers.count, users.count)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadUsers_failure_setsErrorMessage() {
        // Given
        getRandomUsersUseCase.shouldThrow = true

        let expectationError = expectation(description: "Error message set")
        sut.$errorMessage
            .dropFirst()
            .sink { errorMsg in
                if errorMsg != nil {
                    expectationError.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        sut.loadUsers()

        // Then
        wait(for: [expectationError], timeout: 1)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_deleteUser_removesUserFromFilteredAndAllUsers() {
        // Given
        let user1 = makeUser(fullName: "John Doe", email: "john@example.com")
        let user2 = makeUser(fullName: "Jane Smith", email: "jane@example.com")
        sut.filteredUsers = [user1, user2]
        sut.allUsers = [user1, user2]

        // When
        sut.deleteUser(at: 0)

        // Then
        XCTAssertEqual(deleteUserUseCase.deletedIndex, 0)
        XCTAssertEqual(sut.filteredUsers.count, 1)
        XCTAssertEqual(sut.filteredUsers.first?.email, "jane@example.com")
        XCTAssertEqual(sut.allUsers.count, 1)
    }

    func test_searchText_setsFilteredUsersUsingSearchUseCase() {
        // Given
        let user1 = makeUser(fullName: "John Doe", email: "john@example.com")
        let user2 = makeUser(fullName: "Jane Smith", email: "jane@example.com")
        sut.allUsers = [user1, user2]

        searchUsersUseCase.filteredUsersToReturn = [user2]

        // When
        sut.searchText = "Jane"

        // Then
        XCTAssertEqual(sut.filteredUsers.count, 1)
        XCTAssertEqual(sut.filteredUsers.first?.fullName, "Jane Smith")
    }

    // MARK: - Helpers

    private func makeUser(fullName: String, email: String) -> RandomUsersModel {
        RandomUsersModel(
            gender: "male",
            name: "",
            surname: "",
            fullName: fullName,
            email: email,
            phone: "",
            pictureURL: "",
            street: "",
            city: "",
            state: "",
            registeredDate: ""
        )
    }
}
