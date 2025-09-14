import Foundation

protocol RandomUsersRepositoryContract {
    func getRandomUsers(page: Int) async throws -> [RandomUsersModel]
    func delete(at index: Int)
}

final class RandomUsersRepository: RandomUsersRepositoryContract {
    private let remoteDataSource: RandomUsersRemoteDataSourceContract
    private let localDataSource: RandomUserLocalDataSourceContract
    private let mapper: RandomUsersEntityMapperContract
    
    private var blockedEmails: Set<String> = []

    init(remoteDataSource: RandomUsersRemoteDataSourceContract = RandomUsersRemoteDataSource(),
         localDataSource: RandomUserLocalDataSourceContract = RandomUserLocalDataSource(),
         mapper: RandomUsersEntityMapperContract = RandomUsersEntityMapper()) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.mapper = mapper
        
        self.blockedEmails = localDataSource.loadBlockedEmails()
    }
    
    func getRandomUsers(page: Int) async throws -> [RandomUsersModel] {
        let localUsers = loadLocalUsers()
        let filteredLocalUsers = localUsers.filter { !blockedEmails.contains($0.email.lowercased()) }
        var combinedUsers = filteredLocalUsers

        do {
            let remoteUsers = try await fetchRemoteUsers(page: page)
            let filteredRemoteUsers = filterRemoteUsersByEmail(remoteUsers, filteredLocalUsers)
                .filter { !blockedEmails.contains($0.email.lowercased()) }
            
            combinedUsers += filteredRemoteUsers
            
            try saveToLocal(combinedUsers)
        } catch {
            print("Error fetching/saving remote data: \(error)")
        }
        
        return mapper.map(combinedUsers)
    }
    
    func delete(at index: Int) {
        var localUsers = loadLocalUsers().filter { !blockedEmails.contains($0.email.lowercased()) }
        guard index >= 0 && index < localUsers.count else { return }
        
        let userToDelete = localUsers[index]
        let normalizedEmail = userToDelete.email.lowercased()
        
        blockedEmails.insert(normalizedEmail)
        localDataSource.saveBlockedEmails(blockedEmails)
        
        localUsers.remove(at: index)
        do {
            try saveToLocal(localUsers)
        } catch {
            print("Error saving local users after delete: \(error)")
        }
    }
}

private extension RandomUsersRepository {
    func loadLocalUsers() -> [UserEntity] {
        do {
            return try localDataSource.load(as: [UserEntity].self)
        } catch {
            print("No se pudieron cargar datos locales: \(error)")
            return []
        }
    }

    func fetchRemoteUsers(page: Int) async throws -> [UserEntity] {
        let remoteEntity = try await remoteDataSource.getRandomUsers(page: page)
        return remoteEntity.results
    }

    func filterRemoteUsersByEmail(_ remoteUsers: [UserEntity], _ localUsers: [UserEntity]) -> [UserEntity] {
        let localEmails = Set(localUsers.map { $0.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) })
        
        var seenEmails = Set<String>()
        let uniqueRemote = remoteUsers.filter { user in
            let normalizedEmail = user.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            guard !seenEmails.contains(normalizedEmail) else { return false }
            seenEmails.insert(normalizedEmail)
            return true
        }
        
        return uniqueRemote.filter {
            !localEmails.contains($0.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    func saveToLocal(_ users: [UserEntity]) throws {
        try localDataSource.save(users)
    }
}

