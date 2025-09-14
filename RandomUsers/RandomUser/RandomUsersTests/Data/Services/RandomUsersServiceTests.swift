import XCTest
@testable import RandomUser

final class RandomUsersServiceTests: XCTestCase {

    // MARK: - System Under Test
    private var sut: RandomUsersService!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        let mockSession = makeMockSession()
        sut = RandomUsersService(session: mockSession)
    }

    override func tearDown() {
        sut = nil
        URLProtocolMock.mockData = nil
        URLProtocolMock.mockResponse = nil
        URLProtocolMock.mockError = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_fetchRandomUsers_success_returnsData() async throws {
        let expectedData = """
        {
            "results": [],
            "info": {
                "seed": "abc",
                "results": 10,
                "page": 1,
                "version": "1.3"
            }
        }
        """.data(using: .utf8)!

        URLProtocolMock.mockData = expectedData
        URLProtocolMock.mockResponse = HTTPURLResponse(
            url: URL(string: "https://randomuser.me/api/")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let data = try await sut.fetchRandomUsers(page: 1)

        // Assert
        XCTAssertEqual(data, expectedData)
    }

    func test_endpointURL_containsCorrectQueryParameters() {
        let endpoint = RandomUsersService.RandomUsersEndpoint(page: 2, results: 15)
        let url = endpoint.url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        // Assert
        let queryItems = components?.queryItems?.reduce(into: [String: String]()) {
            $0[$1.name] = $1.value
        }

        XCTAssertEqual(queryItems?["results"], "15")
        XCTAssertEqual(queryItems?["page"], "2")
        XCTAssertEqual(components?.host, "randomuser.me")
    }
}

private extension RandomUsersServiceTests {
    func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }
}
