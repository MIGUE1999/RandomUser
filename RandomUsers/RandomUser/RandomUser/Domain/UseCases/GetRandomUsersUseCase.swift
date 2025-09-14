protocol GetRandomUsersUseCaseContract {
    func run() async throws -> [RandomUsersModel]
}
final class GetRandomUsersUseCase: GetRandomUsersUseCaseContract {
    private var currentPage = 1
    private let repository: RandomUsersRepositoryContract
    
    init(repository: RandomUsersRepositoryContract = RandomUsersRepository()) {
        self.repository = repository
    }
    
    func run() async throws -> [RandomUsersModel] {
        let users = try await repository.getRandomUsers(page: currentPage)
        currentPage += 1
        return users
    }
}
