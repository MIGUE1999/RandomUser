import Foundation

protocol RandomUsersRemoteDataSourceContract {
    func getRandomUsers(page: Int) async throws -> RandomUsersEntity
}

final class RandomUsersRemoteDataSource: RandomUsersRemoteDataSourceContract {
    private let service: RandomUsersServiceContract
    
    init(service: RandomUsersServiceContract = RandomUsersService()) {
        self.service = service
    }
    
    func getRandomUsers(page: Int) async throws -> RandomUsersEntity {
        let data = try await service.fetchRandomUsers(page: page)

        return try JSONDecoder().decode(RandomUsersEntity.self, from: data)
    }
}

enum DataSourceError: Error {
    case noData
}
