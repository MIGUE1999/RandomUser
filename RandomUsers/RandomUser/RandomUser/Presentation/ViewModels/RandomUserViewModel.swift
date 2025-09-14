import Foundation
import Combine

protocol RandomUserViewModelContract: ObservableObject {
    func loadUsers()
    func deleteUser(at index: Int)
}

final class RandomUsersViewModel: RandomUserViewModelContract {
    private let getRandomUsersUseCase: GetRandomUsersUseCaseContract
    private let deleteUserUseCase: DeleteUserUseCaseContract
    private let searchUsersUseCase: SearchUsersUseCaseContract

    private var canLoadMorePages = true
    var allUsers: [RandomUsersModel] = []

    @Published var filteredUsers: [RandomUsersModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    @Published var searchText: String = "" {
        didSet {
            searchUsers()
        }
    }

    init(
        getRandomUsersUseCase: GetRandomUsersUseCaseContract = GetRandomUsersUseCase(),
        deleteUserUseCase: DeleteUserUseCaseContract = DeleteUserUseCase(),
        searchUseCase: SearchUsersUseCaseContract = SearchUsersUseCase()
    ) {
        self.getRandomUsersUseCase = getRandomUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.searchUsersUseCase = searchUseCase
    }

    func loadUsers() {
        Task { @MainActor in
            guard !isLoading && canLoadMorePages else { return }

            isLoading = true
            errorMessage = nil

            do {
                let newUsers = try await getRandomUsersUseCase.run()
                if newUsers.isEmpty {
                    canLoadMorePages = false
                } else {
                    allUsers.append(contentsOf: newUsers)
                    applyFilter()
                }
            } catch {
                errorMessage = "Error loading users: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    func deleteUser(at index: Int) {
        deleteUserUseCase.run(at: index)

        guard index < filteredUsers.count else { return }
        let userToDelete = filteredUsers[index]
        if let allIndex = allUsers.firstIndex(of: userToDelete) {
            allUsers.remove(at: allIndex)
        }
        filteredUsers.remove(at: index)
    }

    private func searchUsers() {
        applyFilter()
    }

    private func applyFilter() {
        if searchText.isEmpty {
            filteredUsers = allUsers
        } else {
            filteredUsers = searchUsersUseCase.run(users: allUsers, searchText: searchText)
        }
    }
}
