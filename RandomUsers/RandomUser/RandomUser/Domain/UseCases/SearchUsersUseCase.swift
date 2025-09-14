protocol SearchUsersUseCaseContract {
    func run(users: [RandomUsersModel], searchText: String) -> [RandomUsersModel]
}

final class SearchUsersUseCase: SearchUsersUseCaseContract {
    func run(users: [RandomUsersModel], searchText: String) -> [RandomUsersModel] {
        guard !searchText.isEmpty else {
            return users
        }

        return users.filter {
            $0.fullName.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }
}
