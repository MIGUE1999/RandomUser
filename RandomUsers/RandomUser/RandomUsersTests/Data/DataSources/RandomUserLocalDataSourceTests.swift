import XCTest

@testable import RandomUser

final class RandomUserLocalDataSourceTests: XCTestCase {

    private var sut: RandomUserLocalDataSource!
    private var testDocumentsDirectory: URL!

    override func setUp() {
        super.setUp()
        testDocumentsDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: testDocumentsDirectory, withIntermediateDirectories: true)
        sut = RandomUserLocalDataSource(documentsDirectory: testDocumentsDirectory)
        UserDefaults.standard.removeObject(forKey: "blockedEmails")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: testDocumentsDirectory)
        UserDefaults.standard.removeObject(forKey: "blockedEmails")
        sut = nil
        super.tearDown()
    }

    func test_save_and_load_items() throws {
        // Given
        let users = [
            TestUser(name: "Alice", age: 30),
            TestUser(name: "Bob", age: 25)
        ]

        // When
        try sut.save(users)
        let loadedUsers: [TestUser] = try sut.load(as: [TestUser].self)

        // Then
        XCTAssertEqual(loadedUsers.count, users.count)
        XCTAssertEqual(loadedUsers[0], users[0])
        XCTAssertEqual(loadedUsers[1], users[1])
    }

    func test_load_blockedEmails_returnsEmptySetIfNone() {
        let blocked = sut.loadBlockedEmails()
        XCTAssertTrue(blocked.isEmpty)
    }

    func test_save_and_load_blockedEmails() {
        // Given
        let emails: Set<String> = ["test@example.com", "blocked@example.com"]

        // When
        sut.saveBlockedEmails(emails)
        let loadedEmails = sut.loadBlockedEmails()

        // Then
        XCTAssertEqual(loadedEmails, emails)
    }
}

private struct TestUser: Codable, Equatable {
    let name: String
    let age: Int
}
