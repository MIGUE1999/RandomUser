@testable import RandomUser

final class SearchUsersUseCaseMock: SearchUsersUseCaseContract {
    var filteredUsersToReturn: [RandomUsersModel] = []

    func run(users: [RandomUsersModel], searchText: String) -> [RandomUsersModel] {
        return filteredUsersToReturn
    }
}
