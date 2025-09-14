import Foundation

protocol RandomUsersServiceContract {
    func fetchRandomUsers(page: Int) async throws -> Data
}

final class RandomUsersService: RandomUsersServiceContract {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRandomUsers(page: Int) async throws -> Data {
        let endpoint = RandomUsersEndpoint(page: page, results: 10)
        let request = URLRequest(url: endpoint.url)
        
        let (data, _) = try await session.data(for: request)
        return data
    }
    
    struct RandomUsersEndpoint: ApiEndpointContract {
        let baseURL = URL(string: "https://randomuser.me/api/")!
        let page: Int
        let results: Int
        
        var queryParameters: [String: String] {
            return [
                "results": "\(results)",
                "page": "\(page)"
            ]
        }
        
        var url: URL {
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            components.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            return components.url!
        }
    }
}
